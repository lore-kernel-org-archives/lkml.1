Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZLEHgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZLEHgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 02:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZLEHgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 02:36:47 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:48144 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbZLEHgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 02:36:46 -0500
Date: Sat, 5 Dec 2009 08:36:52 +0100
From: Andreas Mohr <andi@lisas.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ondrej Zary <linux@rainbow-software.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Message-ID: <20091205073652.GA30203@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0912031710130.4795-100000@iolanthe.rowland.org>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Furthermore, the patch shows that the second-to-last argument to 
> usb_fill_bulk_urb() -- the completion function -- is NULL.  That is 
> strictly illegal and it should have caused an oops as soon as the URB 
> was used.

Then there's definitely a WARN_ON or so missing in
static inline void usb_fill_bulk_urb()

And highly likely more checks in those areas that are causing my (and
other people's) ftdi_sio tests and USB audio (MIPS mmap) to fail.
Followup soon.

Andreas Mohr
