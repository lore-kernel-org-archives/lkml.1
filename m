Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYGIXrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYGIXrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 19:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYGIXq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 19:46:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38506 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751841AbYGIXq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 19:46:59 -0400
Date: Thu, 10 Jul 2008 00:14:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, alan@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the epca driver to permit epca_setup() to be
 invoked from the kernel cmdline
Message-ID: <20080710001403.6f91ffff@the-village.bc.nu>
In-Reply-To: <20080709145458.0ccde09d.akpm@linux-foundation.org>
References: <20080709131927.639.72528.stgit@warthog.procyon.org.uk>
	<20080709153906.41711e65@the-village.bc.nu>
	<20080709145458.0ccde09d.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 14:54:58 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 9 Jul 2008 15:39:06 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > Will add to the ttydev tree.
> 
> What is the scope/mandate of that tree?

TTY stuff - thro me any other tty bits you've got and I'll sort them out:
However none of

nwflash-use-simple_read_from_buffer.patch
dsp56k-bkl-pushdown.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
if-0-hpet_unregister.patch
efirtc-push-down-the-bkl.patch

appear to be tty patches

Alan
