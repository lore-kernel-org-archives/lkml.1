Return-Path: <linux-kernel-owner+w=401wt.eu-S1762884AbZBYXoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762884AbZBYXoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZBYXoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:44:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60635 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZBYXoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:44:01 -0500
Message-ID: <49A5D76A.3010301@zytor.com>
Date: Wed, 25 Feb 2009 15:42:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
> 
> Because of 63-sector legacy problems a bunch of ATA vendors will
> initially ship 512/4096 drives that are not naturally aligned.
> I.e. logical sector 63 will be aligned on a 4KB hardware sector
> boundary to overcome the misaligned default partitioning.
> 

I was under the impression Vista didn't do this?  Is there any way to 
force these drives into a sane mode (at the expense of a total data loss)?

	-hpa
