Return-Path: <linux-kernel-owner+w=401wt.eu-S1761215AbZASNGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215AbZASNGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761239AbZASNEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:04:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34198 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761228AbZASNEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:04:45 -0500
Date: Mon, 19 Jan 2009 08:03:37 -0500
From: Josef Bacik <jbacik@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Btrfs: use BTRFS_VOL_NAME_MAX for struct
	btrfs_ioctl_vol_args
Message-ID: <20090119130337.GA25475@unused.rdu.redhat.com>
References: <20090119125732.GA7424@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090119125732.GA7424@hack.private>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 08:57:32PM +0800, Américo Wang wrote:
> 
> I found userspace tool, btrfsctl, uses BTRFS_VOL_NAME_MAX, and
> it also looks that this one is more proper.
> 
> Kill BTRFS_PATH_NAME_MAX since no one will use it.
> 

Nope, BTRFS_PATH_NAME_MAX is specifically used for the ioctl stuff, makes the
arguments 4k aligned, this patch is incorrect.  Thanks,

Josef
