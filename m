Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbYLEKBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbYLEKBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYLEKBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:01:12 -0500
Received: from tundra.namei.org ([65.99.196.166]:52465 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYLEKBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:01:11 -0500
Date: Fri, 5 Dec 2008 21:00:54 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
       Casey Schaufler <casey@schaufler-ca.com>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Matthew N. Dodd" <matthew.dodd@sparta.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, Labeled NFS <labeled-nfs@linux-nfs.org>
Subject: Re: [PATCH 14/14] NFSD: Server implementation of MAC Labeling
In-Reply-To: <1227733394-1114-15-git-send-email-dpquigl@tycho.nsa.gov>
Message-ID: <alpine.LRH.1.10.0812052046520.14142@tundra.namei.org>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov> <1227733394-1114-15-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, David P. Quigley wrote:

> +	err = 0;
> +	(void)security_inode_getsecctx(dentry->d_inode, &context, &len);
> +	if (len < 0)
> +		return nfserrno(len);

So, with the simpler version:

	err = security_inode_getsecctx(dentry->d_inode, &context, &len);
	if (err)
		return nfserrno(err);




-- 
James Morris
<jmorris@namei.org>
