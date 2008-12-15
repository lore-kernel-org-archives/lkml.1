Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYLOUyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYLOUyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYLOUyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:54:37 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:44125 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbYLOUyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:54:36 -0500
Subject: Re: problem with git.kernel.org
From: Chris Mason <chris.mason@oracle.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: devzero@web.de, linux-kernel@vger.kernel.org
In-Reply-To: <49465862.9090400@s5r6.in-berlin.de>
References: <543076374@web.de>  <49465862.9090400@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 15:54:20 -0500
Message-Id: <1229374460.16295.24.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4946C400.0099:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 14:15 +0100, Stefan Richter wrote:
> devzero@web.de wrote:
> [I wrote]
> >> The kernel repo is more than 100 times as big as this emerald repo, 400
> >> times as big perhaps.  
> > 
> > yes, but http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable-standalone.git
> > is a small repository, just containing the btrfs driver.
> 
> Right, I missed that.
> 
> ...
> >> Try to download with git.
> > 
> > i did, but it didn`t work either. i`m behind a http proxy.
> 
> Right again,
> $ git clone \
> http://www.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable-standalone.git
> fails here after a few objects with
> Cannot obtain needed blob ca442d313d86dc67e0a2e5d584b465bd382cbf5c
> while processing commit 96dd95de14c77309abd2521d06c4825162b85e0a.
> fatal: Fetch failed.
> 
> Chris, you should enable fetching over http by
> $ cd /pub/scm/linux/kernel/git/mason/btrfs-unstable-standalone.git
> $ cp -p hooks/post-update.sample hooks/post-update
> Also run git-update-server-info unless you are pushing something soon
> again anyway.
> 

Thanks for the hint.

I fixed the missing commit, but in this case the stand alone tree is
actually generated from the full kernel tree and has an alternates entry
pointing to the full kernel tree.  The end result was not at all good
for http clones.

So I've redone the stand alone tree a bit and it is now a clone of the
clone of the second child of the 3rd son of the original unstable tree.
Hopefully it'll work better, at least http clones work for me now.

-chris


