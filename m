Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYKNTDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYKNTDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYKNTDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:03:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53914 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752042AbYKNTDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:03:06 -0500
Date: Fri, 14 Nov 2008 19:01:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix an uninitialised variable warning in the 8250
 driver
Message-ID: <20081114190149.7f5c20f2@lxorguk.ukuu.org.uk>
In-Reply-To: <26417.1226681468@redhat.com>
References: <20081114163428.7b676742@lxorguk.ukuu.org.uk>
	<20081114162038.23016.20581.stgit@warthog.procyon.org.uk>
	<26417.1226681468@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 16:51:08 +0000
David Howells <dhowells@redhat.com> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > Current versions of gcc that I've tested get this all correct just fine
> > for x86 at least.
> 
> gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)

Newer gcc (4.3 and above) gets it right.

> x86_64 - which doesn't do that.  It uses asm volatile and an infinite for-loop.

Which it seems 4.3 knows about

> Surely having BUG() retreat through a noreturn function may lose important
> state, such as the function that issued the bug as the compiler is under no
> requirement to save the return value, and the file/line info may not be
> available.

Its arch specific code so arch specific things can be done.

Alan
