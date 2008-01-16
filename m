Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYAPKCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYAPKCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 05:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYAPKCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 05:02:36 -0500
Received: from kolab.mylinuxtime.de ([212.112.242.22]:53989 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbYAPKCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 05:02:34 -0500
X-Spam-ASN: AS24900 212.112.224.0/19
From: Christian Hesse <mail@earthworm.de>
To: btrfs-devel@oss.oracle.com
Subject: Re: [Btrfs-devel] [ANNOUNCE] Btrfs v0.10 (online growing/shrinking, ext3 conversion, and more)
Date: Wed, 16 Jan 2008 11:02:11 +0100
User-Agent: KMail/1.9.7
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20080115105238.4fc3e992@think.oraclecorp.com>
In-Reply-To: <20080115105238.4fc3e992@think.oraclecorp.com>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161102.22010.mail@earthworm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008, Chris Mason wrote:
> Hello everyone,
>
> Btrfs v0.10 is now available for download from:

It does not even compile for me, tested with 2.6.24-rc{7,8}. I will look at 
that later.

fs/built-in.o: In function `btrfs_xattr_set_acl':
acl.c:(.text+0x68f33): undefined reference to `posix_acl_from_xattr'
acl.c:(.text+0x68f47): undefined reference to `posix_acl_valid'
make: *** [.tmp_vmlinux1] Error 1

Is this release supposed to fix the suspend problem?
-- 
Regards,
Chris
