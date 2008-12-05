Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbYLECjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbYLECjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 21:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbYLECjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 21:39:07 -0500
Received: from tundra.namei.org ([65.99.196.166]:54398 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbYLECjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 21:39:04 -0500
Date: Fri, 5 Dec 2008 13:38:22 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, "Matthew N. Dodd" <matthew.dodd@sparta.com>,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 08/14] NFSv4: Add label recommended attribute and NFSv4
 flags
In-Reply-To: <1227733394-1114-9-git-send-email-dpquigl@tycho.nsa.gov>
Message-ID: <alpine.LRH.1.10.0812051337050.12208@tundra.namei.org>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov> <1227733394-1114-9-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, David P. Quigley wrote:

> --- a/include/linux/nfs_xdr.h
> +++ b/include/linux/nfs_xdr.h
> @@ -57,6 +57,10 @@ struct nfs_fattr {
>  	__u64			pre_change_attr;/* pre-op NFSv4 change attribute */
>  	unsigned long		time_start;
>  	unsigned long		gencount;
> +#ifdef CONFIG_SECURITY
> +	void			*label;
> +	__u32			 label_len;
> +#endif

Should this be CONFIG_NFS_V4_SECURITY_LABEL ?


-- 
James Morris
<jmorris@namei.org>
