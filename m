Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYEMIdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYEMIdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbYEMIdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:33:09 -0400
Received: from ns.unixsol.org ([193.110.159.2]:39243 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618AbYEMIdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:33:08 -0400
Message-ID: <48295240.4030301@unixsol.org>
Date: Tue, 13 May 2008 11:33:04 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Organization: Unix Solutions Ltd.
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: FD Cami <francois.cami@free.fr>
CC: Donald Douwsma <donaldd@sgi.com>, xfs@oss.sgi.com,
       jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       volkerdi@slackware.com
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org>	<48292742.8090409@sgi.com> <20080513075107.2edc44d3@olorin>
In-Reply-To: <20080513075107.2edc44d3@olorin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FD Cami mumbled something about, On 5/13/08 8:51 AM:
> On Tue, 13 May 2008 15:29:38 +1000
> Donald Douwsma <donaldd@sgi.com> wrote:
> 
>> Georgi Chorbadzhiyski wrote:
>>> Hi guys, I know that not all kernel thread users are converted to
>>> start only when needed but the following is little annoying specially
>>> when I'm not even using jfs, xfs and gfs2.
>>>
>>> Look at the ps output from a standard distro 2.6.24.5 kernel after a
>>> fresh boot:
>> ...
>>
>>> Kernel config can be found here:
>>>   http://mirrors.unixsol.org/slackware/slackware-12.1/kernels/hugesmp.s/config
>>>
>> Your distro is building all of these modules into the kernel.
>> 	CONFIG_XFS_FS=y
>> 	CONFIG_JFS_FS=y
>> 	CONFIG_GFS2_FS=y
>>
>> This isnt exactly standard practice, normally they'd be set to =m and only
>> used if required to mount a filesystem. You may want to ask the slackware
>> people why they chose to do this for their hugexxx.s kernels.
> 
> To be able to use those filesystems on root partitions without requiring
> an initrd. 
> 
> Georgi might be interested to use the generic kernel instead of the huge
> one, it is available there :
> http://mirrors.unixsol.org/slackware/slackware-12.1/slackware/a/kernel-generic-smp-2.6.24.5_smp-i686-2.tgz

I'm well aware of this kernels but I prefer to not use
initrd when possible and still have most of the functionality
available.

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/

