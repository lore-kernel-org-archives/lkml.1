Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYABGk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYABGk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 01:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbYABGkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 01:40:20 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:50068 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYABGkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 01:40:18 -0500
Date: Wed, 02 Jan 2008 00:39:10 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv + ADMA + Samsung disk problem
In-reply-to: <477B2CE4.8070602@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Gabor Gombas <gombasg@sztaki.hu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kluo@nvidia.com, AMartin@nvidia.com, pchen@nvidia.com
Message-id: <477B318E.4030309@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu>
 <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com>
 <477B0CFD.1030603@shaw.ca> <477B10F2.9000107@shaw.ca>
 <477B1233.3090706@gmail.com> <477B2CE4.8070602@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> Thanks a lot for the detailed explanation.  Nvidia ppl, any ideas?
>> FLUSH is used regularly.  We really need to fix this.
> 
> 
> I reiterate my opinion :)  ...   We should remove ADMA support from 
> sata_nv.  It's only in a few chips, it's not appearing in any new chips, 
> and nasty problems have lingered since ADMA support was introduced.
> 
> Definitely sounds like we should disable ADMA by default for 2.6.24-rc, 
> too.

I wouldn't agree.. It's only in a few chips (CK804/MCP04), but those 
chips are very common in desktop, workstation, even some server 
machines. Given the huge number of these chips out there, problem 
reports have been quite rare.
