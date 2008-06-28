Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYF1Ret@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYF1Ret (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 13:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYF1Rej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 13:34:39 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:39100 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYF1Rei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 13:34:38 -0400
Message-ID: <48667624.1090904@linux.vnet.ibm.com>
Date: Sat, 28 Jun 2008 23:04:28 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       xfs-masters@oss.sgi.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 27 - randconfig build
 fails with !CONFIG_XFS_POSIX_ACL
References: <20080627182406.a54b00c1.sfr@canb.auug.org.au> <4865304C.3020301@linux.vnet.ibm.com> <20080628110518.5ae86cd6.sfr@canb.auug.org.au>
In-Reply-To: <20080628110518.5ae86cd6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Kamalesh.
> 
> On Fri, 27 Jun 2008 23:54:12 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>> randconfig build on x86_64 machine fails with build failure
>>
>>   CC [M]  fs/xfs/linux-2.6/xfs_xattr.o
>> fs/xfs/linux-2.6/xfs_xattr.c: In function ‘xfs_decode_acl’:
>> fs/xfs/linux-2.6/xfs_xattr.c:40: error: ‘_ACL_TYPE_ACCESS’ undeclared (first use in this function)
>> fs/xfs/linux-2.6/xfs_xattr.c:40: error: (Each undeclared identifier is reported only once
>> fs/xfs/linux-2.6/xfs_xattr.c:40: error: for each function it appears in.)
>> fs/xfs/linux-2.6/xfs_xattr.c:42: error: ‘_ACL_TYPE_DEFAULT’ undeclared (first use in this function)
> 
> Are you sure your sources are OK?  The patch "xfs fix 1" (which is the
> second last commit in the next20080627 tree) is supposed to fix that.
> 
Your right, the sources did not have the commit. Sorry for the noise.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
