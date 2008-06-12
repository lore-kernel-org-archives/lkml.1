Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbYFLVPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbYFLVPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYFLVOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:14:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47902 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751047AbYFLVOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:14:50 -0400
Date: Thu, 12 Jun 2008 17:14:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: AntonioLin <antonio.lin@alcormicro.com>,
       David Vrabel <david.vrabel@csr.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [S] Re: [linux-uwb] packet size problem
In-Reply-To: <20080611145349.GD20851@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.0806121713330.27763-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008, Jens Axboe wrote:

> > Jens, this is a question for you.  How come we're getting an SG element
> > whose lenth is 3584 when the request_queue's dma_alignment mask is set
> > to 1023?  Is dma_alignment not the right parameter to set?
> 
> dma_alignment mask is the buffer address alignment, so they are not
> completely the same. But it does sound odd, since you would then be
> spanning two pages for that sg element. Is this before or after dma
> mapping the sg table?

Any followup on this?  Is there a different way to request that each SG 
element (except the last) has length divisible by 1024, other than 
setting the dma_alignment mask to 1023?

Alan Stern

