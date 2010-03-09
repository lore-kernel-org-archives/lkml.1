Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab0CIE5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 23:57:53 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:43655 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab0CIE5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 23:57:50 -0500
To: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Cc: "Tejun Heo" <tj@kernel.org>, "Karel Zak" <kzak@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       <linux-ide@vger.kernel.org>, "lkml" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Mark Lord" <kernel@teksavvy.com>,
       <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       <hirofumi@mail.parknet.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <irtiger@gmail.com>,
       "Matthew Wilcox" <matthew@wil.cx>, <aschnell@suse.de>,
       <knikanth@suse.de>, <jdelvare@suse.de>,
       "Jim Meyering" <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net>
	<20100308195847.GC18077@nb.net.home> <4B95B39C.70402@kernel.org>
	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD78@wdscexbe01.sc.wdc.com>
Date: Mon, 08 Mar 2010 23:54:59 -0500
In-Reply-To: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD78@wdscexbe01.sc.wdc.com>
	(Daniel Taylor's message of "Mon, 8 Mar 2010 19:38:53 -0800")
Message-ID: <yq1zl2i6qn0.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B95D504.0118:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "DLT" == Daniel Taylor <Daniel.Taylor@wdc.com> writes:

DLT> Simple reality is that XP is "forever".  Drives >2TiB, which may be
DLT> USB-attached, used with XP will be MBR-partitioned and use
DLT> 4096-byte sectors.  We need to be able to read/write those disks on
DLT> Linux systems.

Shouldn't be a problem as long as the DOS partition table vs. 4 KiB
sectors thing is fixed.


DLT> One last comment: I just tried to partition and format a >2TiB
DLT> drive on fully updated Ubuntu 9.10 with GParted.  I selected not to
DLT> cylinder align, use GPT and ext3, and to put 1 MiB preceeding and
DLT> following.  libparted failed with "unable to satisfy all
DLT> constraints of the partition".  Using "parted", I created the
DLT> partition, and then GParted was able to apply the ext3 file system.

I don't think ubuntu has adopted any of the relevant updates yet.

I believe the Fedora 13 Alpha is due to be released this week.  That
would be the best test platform because several of the people who have
been actively engaged in the 4 KiB sector enablement process are Fedora
developers.

-- 
Martin K. Petersen	Oracle Linux Engineering
