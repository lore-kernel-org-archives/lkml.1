Return-Path: <linux-kernel-owner+w=401wt.eu-S1763323AbZBYX6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763323AbZBYX6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759977AbZBYX5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:57:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759641AbZBYX5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:57:46 -0500
Message-ID: <49A5DAE7.3060409@zytor.com>
Date: Wed, 25 Feb 2009 15:57:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>	<49A5D76A.3010301@zytor.com> <yq11vtmhy0x.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq11vtmhy0x.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
> 
> Modern Windows aligns the first partition on a 1 MB boundary.
> 
> As far as disks go, initially the plan was to have "legacy" branded
> drives with 63-sector alignment.  But I think that has been abandoned in
> favor of instant one-time formatting.  I.e. you can pick your poison
> *once* and that formatting will be done in constant time.  Any
> subsequent changes to blocking and alignment will require a real
> low-level format.
> 

Why one-time?

	-hpa
