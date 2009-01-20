Return-Path: <linux-kernel-owner+w=401wt.eu-S1761318AbZATNLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318AbZATNLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZATNL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:11:27 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:55319 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbZATNLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:11:25 -0500
Subject: Re: Warning and BUG with btrfs and corrupted image
From: Chris Mason <chris.mason@oracle.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
In-Reply-To: <20090120063150.GC5854@alice>
References: <20090113142147.GE16333@alice>
	 <1231857643.29164.28.camel@think.oraclecorp.com>
	 <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz>
	 <20090120063150.GC5854@alice>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 08:11:05 -0500
Message-Id: <1232457065.15042.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4975CD6C.00AB:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 07:31 +0100, Eric Sesterhenn wrote:
> Hi,
> 
> * Pavel Machek (pavel@suse.cz) wrote:
>  
> > Does ext2/3 and vfat survive that kind of attacks? Those are 'in
> > production' and should survive it...
> 
> I regularly (once or twice a week) test 100 corrupted images of 
> vfat, udf, msdos, swap, iso9660, ext2, ext3, ext4, minix, bfs, befs,
> hfs, hfs+, qnx4, affs and cramfs on each of my two test machines.
> 
> They are all pretty stable, one remaining thing on my list i didnt have
> time to look into was an issue with fat (msdos) triggering a bug in
> buffer.c the other is a warning with ext4 in jbd2/checkpoint.c:166
> 
> If there is a filesystem you are interested in thats not on the list
> or that you want me to test a bit more, just let me know
> 

squashfs is in the kernel now, that would be good to see as well.  I
didn't realize you were doing such extensive tests, thanks for doing
them.

-chris


