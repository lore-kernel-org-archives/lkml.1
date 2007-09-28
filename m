Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbXI1SmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbXI1SmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbXI1SmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:42:18 -0400
Received: from verein.lst.de ([213.95.11.210]:48043 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbXI1SmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:42:17 -0400
Date: Fri, 28 Sep 2007 20:42:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: jblunck@suse.de
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       agruen@suse.de, tiwai@suse.de
Subject: Re: [patch 09/10] Use struct path in fs_struct
Message-ID: <20070928184214.GI14269@lst.de>
References: <20070927141200.820970144@X40.localnet> <20070927141229.008500593@X40.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927141229.008500593@X40.localnet>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -	res = __d_path(dentry, vfsmnt, root, rootmnt, buf, buflen);
> +	res = __d_path(dentry, vfsmnt, root.dentry, root.mnt, buf, buflen);

__d_path should probably switch to taking a struct path * aswell.

Otherwise fine.
