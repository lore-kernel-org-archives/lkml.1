Return-Path: <linux-kernel-owner+w=401wt.eu-S1763052AbZBYXys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763052AbZBYXys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZBYXyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:54:36 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:34202 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZBYXyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:54:36 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
	<49A5D55A.9080402@zytor.com>
Date: Wed, 25 Feb 2009 18:51:35 -0500
In-Reply-To: <49A5D55A.9080402@zytor.com> (H. Peter Anvin's message of "Wed\, 25 Feb 2009 15\:33\:46 -0800")
Message-ID: <yq163iyhy7s.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49A5D98A.028E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:

hpa> I wish it was left to people like myself.  Realistically when it
hpa> comes to disks with 4096-byte logical sectors it going to matter
hpa> how the firmware chooses to expose it.

Well. In the short term ATA is going to emulate 512 (at a penalty for
misaligned I/O).  SCSI is switching to 4KB wholesale.

I have a 4KB/4KB drive here that I have had fun booting from the last
few days.


hpa> Most likely, the universe will explode at this time, since very few
hpa> bootloaders can deal with a sector size other than 512 bytes, and
hpa> virtually every partition table format contains a sector size
hpa> dependency, which also means you'll break any mechanical imaging
hpa> solution.

hpa> It's going to hurt :(

Yep, it sucks :|

-- 
Martin K. Petersen	Oracle Linux Engineering
