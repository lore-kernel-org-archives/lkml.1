Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbYEMF35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbYEMF35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 01:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbYEMF3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 01:29:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57878 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754718AbYEMF3r (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 01:29:47 -0400
Message-ID: <48292742.8090409@sgi.com>
Date: Tue, 13 May 2008 15:29:38 +1000
From: Donald Douwsma <donaldd@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Georgi Chorbadzhiyski <gf@unixsol.org>
CC: xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net,
       cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org>
In-Reply-To: <4828CAC6.3090402@unixsol.org>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Georgi Chorbadzhiyski wrote:
> Hi guys, I know that not all kernel thread users are converted to
> start only when needed but the following is little annoying specially
> when I'm not even using jfs, xfs and gfs2.
> 
> Look at the ps output from a standard distro 2.6.24.5 kernel after a
> fresh boot:
...

> 
> Kernel config can be found here:
>   http://mirrors.unixsol.org/slackware/slackware-12.1/kernels/hugesmp.s/config
> 

Your distro is building all of these modules into the kernel.
	CONFIG_XFS_FS=y
	CONFIG_JFS_FS=y
	CONFIG_GFS2_FS=y

This isnt exactly standard practice, normally they'd be set to =m and only
used if required to mount a filesystem. You may want to ask the slackware
people why they chose to do this for their hugexxx.s kernels.

Don



