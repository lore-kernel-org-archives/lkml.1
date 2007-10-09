Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbXJIQ0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbXJIQ0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXJIQ0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:26:25 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:23121 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbXJIQ0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:26:24 -0400
Message-ID: <470BABAC.2030706@msgid.tls.msk.ru>
Date: Tue, 09 Oct 2007 20:26:20 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Andi Kleen <andi@firstfloor.org>, Michael Stiller <ms@2scale.net>,
       linux-kernel@vger.kernel.org
Subject: Re: howto boost write(2) performance?
References: <1191937817.3641.9.camel@blackberry> <p73odf849rq.fsf@bingen.suse.de> <470BA14C.90608@panasas.com>
In-Reply-To: <470BA14C.90608@panasas.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
[]
> If your target is a SCSI target you can gain up to 15% by using
> sg. Search on the net for the "sg utils" package. The source code
> of sg_dd and others are a grate example of how to do it.
> 
> Other wise O_DIRECT is your friend. Also look for asynchronous
> I/O so you have a few pending IO buffers to keep the pipes full.

What's the advantage of sg_io over O_DIRECT to the block device?
I think sg devices are being (slowly?) obsoleted since most stuff
which has been in sg now works over normal block device, no?
At least, I haven't seen any significant difference between
sg_dd and dd with oflag=direct.

Thanks.

/mjt
