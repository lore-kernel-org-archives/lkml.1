Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbYE2Sx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbYE2Sx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYE2SxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:53:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40848 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752190AbYE2SxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:53:15 -0400
Date: Thu, 29 May 2008 19:38:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
Message-ID: <20080529193813.4bc0a677@core>
In-Reply-To: <483EF536.90801@garzik.org>
References: <20080529161453.24735.805.stgit@core>
	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
	<20080529190235.258d304e@core>
	<483EF536.90801@garzik.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 14:25:58 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Alan Cox wrote:
> > maybe_altstatus is crap naming but simply making ata_sff_altstatus fake a
> > reply in arbitary cases risks not catching mistakes and could mean we
> > don't catch corrupting mistakes which would be very bad indeed.
> 
> Please grep the remaining users, IMO you will find that's not really 
> true.  After your patch no core users remain, only ones in a few 
> scattered drivers that most likely want your logic (or a 
> simplified-for-that-controller version thereof).

I did check them all and review them and read the documentation right
back to the original 1010 controller behaviour. I stand by my comment.

Alan
