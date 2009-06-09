Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZFIFlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZFIFlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 01:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZFIFle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 01:41:34 -0400
Received: from sh.osrg.net ([192.16.179.4]:40538 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbZFIFle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 01:41:34 -0400
Date: Tue, 09 Jun 2009 14:41:25 +0900 (JST)
Message-Id: <20090609.144125.88495131.ryusuke@osrg.net>
To: sfr@canb.auug.org.au, viro@ZenIV.linux.org.uk
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       konishi.ryusuke@lab.ntt.co.jp
Subject: Re: linux-next: manual merge of the vfs tree with the nilfs tree
From: Ryusuke Konishi <ryusuke@osrg.net>
In-Reply-To: <20090609111114.2e879a50.sfr@canb.auug.org.au>
References: <20090609111114.2e879a50.sfr@canb.auug.org.au>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Jun 2009 14:41:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Tue, 9 Jun 2009 11:11:14 +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next merge of the vfs tree got a conflicts in
> fs/nilfs2/super.c between commits from the nilfs tree and similar commits
> from the vfs tree.
> 
> The vfs and nilfs trees have different versions of the following patches:
> 
> nilfs2: get rid of sget use for checking if current mount is present
> nilfs2: simplify remaining sget() use
> nilfs2: correct exclusion control in nilfs_remount function
> 
> And the vfs tree has further commits that affect this files as well.
> 
> For now, I have used the vfs tree version.  Please sort this out.

I've confirmed that the patch series is applied to the vfs tree.

To avoid the conflict, I will remove them from my nilfs2 tree.

Thanks,
Ryusuke Konishi
