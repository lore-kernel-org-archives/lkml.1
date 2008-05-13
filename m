Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbYEMIbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbYEMIbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbYEMIbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:31:04 -0400
Received: from ns.unixsol.org ([193.110.159.2]:57231 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbYEMIbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:31:02 -0400
Message-ID: <482951C3.60600@unixsol.org>
Date: Tue, 13 May 2008 11:30:59 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Organization: Unix Solutions Ltd.
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Donald Douwsma <donaldd@sgi.com>
CC: xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net,
       cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org> <48292742.8090409@sgi.com>
In-Reply-To: <48292742.8090409@sgi.com>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Donald Douwsma mumbled something about, On 5/13/08 8:29 AM:
> Georgi Chorbadzhiyski wrote:
>> Hi guys, I know that not all kernel thread users are converted to
>> start only when needed but the following is little annoying specially
>> when I'm not even using jfs, xfs and gfs2.
>>
>> Look at the ps output from a standard distro 2.6.24.5 kernel after a
>> fresh boot:
> ...
> 
>> Kernel config can be found here:
>>   
>> http://mirrors.unixsol.org/slackware/slackware-12.1/kernels/hugesmp.s/config 
> 
> Your distro is building all of these modules into the kernel.
>     CONFIG_XFS_FS=y
>     CONFIG_JFS_FS=y
>     CONFIG_GFS2_FS=y
> 
> This isnt exactly standard practice, normally they'd be set to =m and only
> used if required to mount a filesystem. You may want to ask the slackware
> people why they chose to do this for their hugexxx.s kernels.

I know that they are compiled in the kernel, but since they
are not used isn't starting their own kthreads kind of
unnecessary? Surely the threads can be started on demand
only when xfs/etc volume is mounted.

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/

