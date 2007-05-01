Return-Path: <linux-kernel-owner+w=401wt.eu-S1945961AbXEAAKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945961AbXEAAKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946157AbXEAAKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:10:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:48242 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945961AbXEAAJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:09:59 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 1 May 2007 10:09:40 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17974.34116.479061.912980@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: nfsd/md patches Re: 2.6.22 -mm merge plans
In-Reply-To: message from Andrew Morton on Monday April 30
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday April 30, akpm@linux-foundation.org wrote:
> 
>  remove-nfs4_acl_add_ace.patch
>  the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
>  knfsd-rename-sk_defer_lock-to-sk_lock.patch
>  nfsd-nfs4state-remove-unnecessary-daemonize-call.patch
>  rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
> 
> nfsd things - will merge after checking with Neil.
> 

All acked, though that last one won't fix any oopses like the comment
hopes for - I really should look into that.


> 
>  drivers-mdc-use-array_size-macro-when-appropriate.patch
>  md-cleanup-use-seq_release_private-where-appropriate.patch
>  md-remove-broken-sigkill-support.patch
> 
> Will merge after checking with Neil

NAK on md-remove-broken-sigkill-support.patch - I'll follow up the
original mail.

ACK on the other two.


> 
>  md-dm-reduce-stack-usage-with-stacked-block-devices.patch
> 
> Will we ever fix this?
> 

I think we have several votes for "just merge it".  I don't think
there are known problems with it.

NeilBrown
