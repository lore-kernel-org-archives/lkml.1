Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZEYVYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZEYVYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZEYVY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:24:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55496 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZEYVY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:24:26 -0400
Date: Tue, 26 May 2009 00:23:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
Message-ID: <20090525212325.GD6856@redhat.com>
References: <20090525205353.GB6856@redhat.com> <Pine.LNX.4.44L0.0905251704490.27717-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905251704490.27717-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 05:08:12PM -0400, Alan Stern wrote:
> On Mon, 25 May 2009, Michael S. Tsirkin wrote:
> 
> > > So apparently this is a bug in the device; it doesn't respond correctly
> > > to the first READ command.  But since it does respond correctly to 
> > > later commands, everything works okay thereafter.  You ought to be able 
> > > to recover from the error by running
> > > 
> > > 	blockdev --rereadpt /dev/sdb
> > > 
> > > manually.
> > 
> > Yes, this helps.
> > Would it make sense for kernel to retry automatically?
> > Why doesn't it?
> 
> I don't know the details in this case.  Most likely the error code 
> (Logical Block Address Out of Range) is interpreted as a fatal 
> non-retryable error.  For other sorts of errors, the kernel does retry.

Who would know? The scsi crowd?

> > > As far as I can tell, this has nothing to do with any user programs in 
> > > the distribution.  It appears to be entirely the device's fault.
> > > 
> > > Alan Stern
> > 
> > BTW, any idea how come I later get errors apparently from amiga fs?
> 
> Not a clue.  Unless it was some odd side effect of the partition code 
> trying to interpret an uninitialized buffer.
> 
> Alan Stern

-- 
MST
