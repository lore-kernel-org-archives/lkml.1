Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbYLUOpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbYLUOpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYLUOo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:44:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58839 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752637AbYLUOo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:44:57 -0500
Date: Sun, 21 Dec 2008 14:45:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Checking a USB drive's capacity
Message-ID: <20081221144503.16919dc1@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0812182326100.31272-100000@netrider.rowland.org>
References: <20081218224418.01fc26a4@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0812182326100.31272-100000@netrider.rowland.org>
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

On Thu, 18 Dec 2008 23:33:09 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Thu, 18 Dec 2008, Alan Cox wrote:
> 
> > > spun up yet.  Not to mention that it seems strange to read the last
> > > sector before reading the first!
> > 
> > The SCSI CD code deals with this by spotting the error is close to the
> > end and of particular types then interpreting it and adjusting the volume
> > size. This is done because the size value for a CD-R/RW is imprecise.
> 
> Although it may be okay for CDs, I suspect that approach won't work for 
> disks.

Some of the partition formats do indeed go looking for the end of disk so
it won't work in that case.
