Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018Ab0AKH1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab0AKH1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 02:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324Ab0AKH1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 02:27:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0AKH1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 02:27:31 -0500
Message-ID: <4B4AD2CE.8040207@zytor.com>
Date: Sun, 10 Jan 2010 23:27:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Andreas Dilger <adilger@sun.com>, Karel Zak <kzak@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com>	<329167C1-CF54-4742-B0B7-AD0B9DEFDEC1@sun.com> <yq1ocl187ww.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1ocl187ww.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2010 10:36 PM, Martin K. Petersen wrote:
>>>>>> "Andreas" == Andreas Dilger <adilger@sun.com> writes:
> 
> Andreas> I agree whole heartedly.  We steer users very sharply away from
> Andreas> using partitions at all, because on h/w RAID devices the
> Andreas> 512-byte offset from fdisk completely kills RAID-5/6
> Andreas> performance.
> 
> I don't have a problem aligning to 1MB (taking alignment_offset into
> account) by default but there needs to be an easy override.  There are
> RAID arrays that internally compensate for the legacy 63 sector offset
> and we'll cause misalignment if we start at 1MB on those.
> 
> I'm heavily lobbying our storage partners to make sure they fill out the
> right SCSI bits if their LUNs are not naturally aligned.  But there are
> obviously going to be legacy devices out there that will need manual
> alignment compensation.
> 

Yes, but we shouldn't default to braindead mode.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

