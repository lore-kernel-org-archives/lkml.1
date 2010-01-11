Return-Path: <linux-kernel-owner+w=401wt.eu-S1751644Ab0AKGhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab0AKGhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 01:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108Ab0AKGhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 01:37:11 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:42634 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab0AKGhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 01:37:10 -0500
To: Andreas Dilger <adilger@sun.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Karel Zak <kzak@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com>
	<329167C1-CF54-4742-B0B7-AD0B9DEFDEC1@sun.com>
Date: Mon, 11 Jan 2010 01:36:31 -0500
In-Reply-To: <329167C1-CF54-4742-B0B7-AD0B9DEFDEC1@sun.com> (Andreas Dilger's
	message of "Fri, 08 Jan 2010 15:40:33 -0700")
Message-ID: <yq1ocl187ww.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B4AC6FB.00DC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Dilger <adilger@sun.com> writes:

Andreas> I agree whole heartedly.  We steer users very sharply away from
Andreas> using partitions at all, because on h/w RAID devices the
Andreas> 512-byte offset from fdisk completely kills RAID-5/6
Andreas> performance.

I don't have a problem aligning to 1MB (taking alignment_offset into
account) by default but there needs to be an easy override.  There are
RAID arrays that internally compensate for the legacy 63 sector offset
and we'll cause misalignment if we start at 1MB on those.

I'm heavily lobbying our storage partners to make sure they fill out the
right SCSI bits if their LUNs are not naturally aligned.  But there are
obviously going to be legacy devices out there that will need manual
alignment compensation.

-- 
Martin K. Petersen	Oracle Linux Engineering
