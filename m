Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbYJUQf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbYJUQf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYJUQfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:35:14 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:49986 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbYJUQfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:35:12 -0400
Subject: Re: Subject: [PATCH 01/16] Squashfs: inode operations
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>, akpm@linux-foundation.org,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com
In-Reply-To: <20081017165300.GA8076@logfs.org>
References: <E1KqrTW-0001xC-9M@dylan>  <20081017165300.GA8076@logfs.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 21 Oct 2008 12:14:26 -0400
Message-Id: <1224605666.31157.71.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 18:53 +0200, Jörn Engel wrote:
> None of the comments below are a reason against mainline inclusion, imo.
> They should get handled, but whether that happens before or after a
> merge doesn't really matter.
> 
> On Fri, 17 October 2008 16:42:50 +0100, Phillip Lougher wrote:
> > 
> > +#include <linux/squashfs_fs.h>
> > +#include <linux/squashfs_fs_sb.h>
> > +#include <linux/squashfs_fs_i.h>
> 
> Current verdict seems to be that these files should live in fs/squashfs/,
> not include/linux/.  No kernel code beside squashfs needs the headers
> and userspace tools should have a private copy.
> 
[Snip]

I looked at where filesystems such as ext3 store these and it seems to
be in include/linux. I'm assuming this is because usespace utilities
like fsck need them. It seems wrong for userspace tools to have their
own private copy since you can potentially have them out of sync with
the kernel you are running and it provides more chance for you
forgetting to update a structure somewhere. 

Dave

