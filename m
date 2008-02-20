Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbYBTV6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbYBTV6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbYBTV5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:57:55 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41980 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753403AbYBTV5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:57:54 -0500
Date: Wed, 20 Feb 2008 21:48:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "John Stoffel" <john@stoffel.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cyclades: Prepare for relaxed locking in callers
Message-ID: <20080220214847.1a5590c3@core>
In-Reply-To: <18364.39445.347911.402466@stoffel.org>
References: <20080220201216.40d70747@core>
	<18364.39445.347911.402466@stoffel.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 16:22:29 -0500
"John Stoffel" <john@stoffel.org> wrote:

> 
> Alan> Basically wrap it in lock_kernel where it is hard to prove the
> Alan> locking is ok.
> 
> I've got cyclades cards, both ISA and Serial.  Do you want/need any
> specific tests?  Or should I just send you (or your deputy) the ISA
> card for your collection?

At the moment its fairly tricky to test unless you want to hack your tree
up further. The patch prepares for stuff that I've not yet sent Andrew. I
want to make sure we haven't broken anything before sending the small
patches to fire it all up.
