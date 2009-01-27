Return-Path: <linux-kernel-owner+w=401wt.eu-S1751768AbZA0XXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbZA0XXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZA0XXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:23:05 -0500
Received: from mail.fieldses.org ([141.211.133.115]:43060 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZA0XXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:23:04 -0500
Date: Tue, 27 Jan 2009 18:23:04 -0500
To: stable@kernel.org
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, Marc Eshel <eshel@almaden.ibm.com>
Subject: Re: nfsd fixes for 2.6.29
Message-ID: <20090127232304.GD13854@fieldses.org>
References: <20090127232058.GC13854@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127232058.GC13854@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 06:20:58PM -0500, bfields wrote:
> The following changes are available in the git repository at:
> 
>   git://linux-nfs.org/~bfields/linux.git for-2.6.29
> 
> Mainly three regression fixes, but I also snuck in two minor
> documentation updates.  (I can stop that if it's annoying.)
> 
> --b.
> 
> J. Bruce Fields (3):
>       nfs: note that CONFIG_SUNRPC_XPRT_RDMA turns on server side support too
>       nfsd: fix null dereference on error path
>       nfsd: fix cred leak on every rpc
> 
> James Lentini (1):
>       update port number in NFS/RDMA documentation
> 
> Jeff Layton (1):
>       nfsd: only set file_lock.fl_lmops in nfsd4_lockt if a stateowner is found

Jeff's patch (together with the previous patch it fixes) are also
appropriate for stable; I'll follow up with the patches in question.

--b.
