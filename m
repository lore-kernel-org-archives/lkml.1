Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbXKNQAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbXKNQAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXKNQAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:00:06 -0500
Received: from rtr.ca ([76.10.145.34]:4028 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934AbXKNQAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:00:05 -0500
Message-ID: <473B1B83.9020103@rtr.ca>
Date: Wed, 14 Nov 2007 11:00:03 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Sebastian Kemper <sebastian_ml@gmx.net>
Cc: Mark Lord <liml@rtr.ca>, linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu> <20071113232859.GA4681@section-eight> <473B0FA2.5000102@rtr.ca> <20071114153852.GA9019@section-eight>
In-Reply-To: <20071114153852.GA9019@section-eight>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Kemper wrote:
> On Wed, Nov 14, 2007 at 10:09:22AM -0500, Mark Lord wrote:
>> I think the problem here might be that libata doesn't actually support 
>> SG_IO
>> for ATAPI drives prior to 2.6.24 (ugh).
>>
>> Try it with a 2.6.24-rc* kernel from kernel.org, or back-patch the ATA_16
>> SG_IO support into your older kernel.
> 
> Hi Mark,
> 
> I already tried 2.6.24-rc2 and it didn't work, see my last reply:
> http://marc.info/?l=linux-kernel&m=119504244805467&w=2
..
Yeah, I'm a bit drowsy this morning -- the set speed command
doesn't use ATA_16, so it should work with any kernel.

I'll try it here soon-ish, since I need to update "hdparm -E" for libata anyway.

Cheers
