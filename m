Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbYCWRYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbYCWRYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 13:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYCWRYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 13:24:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYCWRYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 13:24:21 -0400
Message-ID: <47E690F6.6030905@zytor.com>
Date: Sun, 23 Mar 2008 10:18:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ultrastor.c is a bit-rot
References: <47DE8736.8020405@panasas.com> <20080317152344.GE26285@parisc-linux.org> <47E41D7D.9050409@zytor.com> <47E628DF.6070301@panasas.com> <47E68423.2010507@zytor.com> <20080323171652.GF10722@ZenIV.linux.org.uk>
In-Reply-To: <20080323171652.GF10722@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> 
> ... not that VLB didn't suck badly with several devices attached at the same
> time.  I would be rather surprised if that board would work if fully populated
> with VLB cards, all in active use.  IOW, a likely explanation is that it
> had a warning along the lines of "use of more than <number> of VLB cards
> at the same time may use instability" buried in documentation and proud
> "6 VLB slots!!!" touted by marketing...
> 
> I can't find VLB specs online, but IIRC 3 had been the limit and anything
> past that had been very much out of spec and likely to screw you.

I think that particular board had multiple root drivers (it was a P5 
board, so it wasn't a "local" bus anyway.)

	-hpa
