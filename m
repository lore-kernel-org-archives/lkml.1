Return-Path: <linux-kernel-owner+w=401wt.eu-S1763507AbZAUPFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763507AbZAUPFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759900AbZAUPFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:05:30 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:39489 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759435AbZAUPF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:05:28 -0500
Subject: Re: [Patch] Btrfs: use BTRFS_VOL_NAME_MAX for struct
 btrfs_ioctl_vol_args
From: Chris Mason <chris.mason@oracle.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <20090119131224.GC7424@hack.private>
References: <20090119125732.GA7424@hack.private>
	 <20090119130337.GA25475@unused.rdu.redhat.com>
	 <20090119131224.GC7424@hack.private>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jan 2009 10:04:08 -0500
Message-Id: <1232550248.17244.7.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4977396C.003A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 21:12 +0800, Américo Wang wrote:
> On Mon, Jan 19, 2009 at 08:03:37AM -0500, Josef Bacik wrote:
> >On Mon, Jan 19, 2009 at 08:57:32PM +0800, Américo Wang wrote:
> >> 
> >> I found userspace tool, btrfsctl, uses BTRFS_VOL_NAME_MAX, and
> >> it also looks that this one is more proper.
> >> 
> >> Kill BTRFS_PATH_NAME_MAX since no one will use it.
> >> 
> >
> >Nope, BTRFS_PATH_NAME_MAX is specifically used for the ioctl stuff, makes the
> >arguments 4k aligned, this patch is incorrect.  Thanks,
> 
> Ok, then what is BTRFS_VOL_NAME_MAX? :)

Right now it is only used in the progs.  The disk format doesn't really
have a max there, it is just to keep names usable.  But, we should add a
check in the kernel ioctl side, are you interested in sending a patch
for it?

-chris


