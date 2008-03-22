Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbYCVE4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbYCVE4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 00:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYCVE4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 00:56:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33554 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYCVE4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 00:56:22 -0400
Date: Sat, 22 Mar 2008 04:56:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com, dhowells@redhat.com
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
Message-ID: <20080322045612.GB10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu> <20080319182005.GP10722@ZenIV.linux.org.uk> <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu> <20080320214319.GS10722@ZenIV.linux.org.uk> <20080322034950.GY10722@ZenIV.linux.org.uk> <20080322041131.GA10722@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322041131.GA10722@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	OK, preliminary patches are in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ expiry-fixes

BTW, cifs use of MNT_SHRINKABLE is broken; it updates mnt_flags on
*mountpoint* instead of just having them set on new vfsmount.
Their expiry policy is also very odd - "expire everything cifs
whenever some cifs filesystem is unmounted".  Hell knows what had
been intended there (dfs_shrink_umount_helper() and friends)...
