Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYAPRrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYAPRrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYAPRrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:47:09 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:47969 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbYAPRrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:47:08 -0500
Subject: Re: [Btrfs-devel] [ANNOUNCE] Btrfs v0.10 (online
	growing/shrinking, ext3 conversion, and more)
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Christian Hesse <mail@earthworm.de>
Cc: btrfs-devel@oss.oracle.com, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <200801161102.22010.mail@earthworm.de>
References: <20080115105238.4fc3e992@think.oraclecorp.com>
	 <200801161102.22010.mail@earthworm.de>
Content-Type: text/plain; charset=utf-8
Date: Wed, 16 Jan 2008 18:50:53 +0100
Message-Id: <1200505853.6461.6.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ons, 16 01 2008 kl. 11:02 +0100, skrev Christian Hesse:
> On Tuesday 15 January 2008, Chris Mason wrote:
> > Hello everyone,
> >
> > Btrfs v0.10 is now available for download from:
> 
> It does not even compile for me, tested with 2.6.24-rc{7,8}. I will look at 
> that later.
> 
> fs/built-in.o: In function `btrfs_xattr_set_acl':
> acl.c:(.text+0x68f33): undefined reference to `posix_acl_from_xattr'
> acl.c:(.text+0x68f47): undefined reference to `posix_acl_valid'
> make: *** [.tmp_vmlinux1] Error 1
> 
See this build fix for kernels without acl by Yan Zheng on the
btrfs-devel list

http://oss.oracle.com/pipermail/btrfs-devel/2008-January/000386.html


Simon Holm Thøgersen

