Return-Path: <linux-kernel-owner+w=401wt.eu-S1030181AbXAaPWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181AbXAaPWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965434AbXAaPWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:22:09 -0500
Received: from rtr.ca ([64.26.128.89]:4948 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965408AbXAaPWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:22:06 -0500
Message-ID: <45C0B41C.4030608@rtr.ca>
Date: Wed, 31 Jan 2007 10:22:04 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <ric@emc.com>, "Eric D. Mudama" <edmudama@gmail.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>	 <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>	 <45BFF3D6.9050605@rtr.ca>  <45C00AEE.1090708@emc.com> <1170217288.10890.37.camel@mulgrave.il.steeleye.com> <45C0B211.2030305@rtr.ca>
In-Reply-To: <45C0B211.2030305@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> James Bottomley wrote:
>>
>> For the MD case, this is what REQ_FAILFAST is for.
> 
> I cannot find where SCSI honours that flag.  James?

Scratch that thought.. SCSI honours it in scsi_end_request().

But I'm not certain that the block layer handles it correctly,
at least not in the 2.6.16/2.6.18 kernel that I'm working with today.

Cheers
