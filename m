Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbXFTXDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbXFTXDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbXFTXCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:02:47 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27874 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbXFTXCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:02:45 -0400
Message-ID: <4679B1F6.6080408@oracle.com>
Date: Wed, 20 Jun 2007 19:02:14 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk> <4679AB39.4010909@oracle.com> <4679AD0F.3040207@zytor.com> <4679AEA7.8050806@oracle.com> <4679B0C5.3030102@zytor.com>
In-Reply-To: <4679B0C5.3030102@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------000004040802090705070307"
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000004040802090705070307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

H. Peter Anvin wrote:
> Chuck Lever wrote:
>> The advantage is that it doesn't have strong user space dependencies on
>> its format like /proc/mounts does.
>>
>> If you have NFS mount points, you will see that it includes a great deal
>> of additional information about each mount.
> 
> OK, I see now:
> device raidtest:/export mounted on /net/raidtest/export with fstype nfs
> statvers=1.0
>         opts:
> rw,vers=3,rsize=131072,wsize=131072,acregmin=3,acregmax=60,acdirmin=30,acdirmax=60,hard,proto=tcp,timeo=600,retrans=2,sec=sys
>         age:    5
>         caps:   caps=0x9,wtmult=4096,dtsize=4096,bsize=0,namelen=255
>         sec:    flavor=1,pseudoflavor=1
>         events: 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
>         bytes:  0 0 0 0 0 0 0 0
>         RPC iostats version: 1.0  p/v: 100003/3 (nfs)
>         xprt:   tcp 686 0 2 0 5 8 8 0 8 0
>         per-op statistics
>                 NULL: 0 0 0 0 0 0 0 0
>              GETATTR: 2 2 0 264 224 1 0 1
>              SETATTR: 0 0 0 0 0 0 0 0
>               LOOKUP: 0 0 0 0 0 0 0 0
>               ACCESS: 1 1 0 116 120 0 0 0
>             READLINK: 0 0 0 0 0 0 0 0
>                 READ: 0 0 0 0 0 0 0 0
>                WRITE: 0 0 0 0 0 0 0 0
>               CREATE: 0 0 0 0 0 0 0 0
>                MKDIR: 0 0 0 0 0 0 0 0
>              SYMLINK: 0 0 0 0 0 0 0 0
>                MKNOD: 0 0 0 0 0 0 0 0
>               REMOVE: 0 0 0 0 0 0 0 0
>                RMDIR: 0 0 0 0 0 0 0 0
>               RENAME: 0 0 0 0 0 0 0 0
>                 LINK: 0 0 0 0 0 0 0 0
>              READDIR: 0 0 0 0 0 0 0 0
>          READDIRPLUS: 0 0 0 0 0 0 0 0
>               FSSTAT: 1 1 0 132 84 0 1 1
>               FSINFO: 1 1 0 132 80 0 0 0
>             PATHCONF: 0 0 0 0 0 0 0 0
>               COMMIT: 0 0 0 0 0 0 0 0
> 
> This format is just awful for parsing.  It's pretty clearly totally
> ad-hoc.  It's not even self-consistent (it uses different separators,
> etc, in the same file!)  It's reasonably compact for human consumption,
> but it doesn't show what the arrays mean.
> 
> Heck, XML would have been better than this mess...

Sigh.  So where where you when I asked for review time and again?

I have a couple of simple Python scripts that can parse this without any 
difficulty.

I resent your tone.  Quite a bit.

--------------000004040802090705070307
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
url:http://oss.oracle.com/~cel/
version:2.1
end:vcard


--------------000004040802090705070307--
