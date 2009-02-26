Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbZBZPRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbZBZPRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 10:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbZBZPR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 10:17:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZBZPR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 10:17:27 -0500
Message-ID: <49A6B272.2070905@zytor.com>
Date: Thu, 26 Feb 2009 07:17:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx> <49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net> <49A5D55A.9080402@zytor.com> <20090226124339.GA10548@nb.net.home>
In-Reply-To: <20090226124339.GA10548@nb.net.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak wrote:
> On Wed, Feb 25, 2009 at 03:33:46PM -0800, H. Peter Anvin wrote:
>> virtually every partition table format contains a sector size  
>> dependency
> 
>  Is it true that "every partition table format"? I see in
>  fs/partitions/ that only ibm.c and msdos.c care about a sector size.
>  It seems that the others formats are based on 512 sectors only.
> 

And do they do so correctly?

Looking at the UEFI spec for one, the GPT partition table format
definitely has a logical sector size dependency.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

