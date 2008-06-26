Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbYFZOSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbYFZOSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbYFZOSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:18:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38177 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756309AbYFZOSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:18:31 -0400
Date: Thu, 26 Jun 2008 10:18:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, <andi@firstfloor.org>,
       <linux-kernel@vger.kernel.org>, <antonio.lin@alcormicro.com>,
       <david.vrabel@csr.com>
Subject: Re: Scatter-gather list constraints
In-Reply-To: <20080626063559.GJ20851@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.0806261016590.2811-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008, Jens Axboe wrote:

> I don't think adding anything in the general IO path makes a lot of
> sense, this is a really screwy case. I don't mind adding work-arounds to
> the block layer to cater for hardware weirdness, but this is getting a
> little silly. We could provide a helper function for 'bouncing' this
> request and thus reuse the block bounce buffer for this, but I'm not
> even sure how to simply express this generically. As it is likely of no
> use outside of this specific case, putting it in the driver (or usb
> layer, if you expect more of these similar cases) is the best option.

That sounds great.  If any of you could provide the bounce-buffer 
helper functions, I will be pleased to write the USB-specific code to 
call them.

Alan Stern

