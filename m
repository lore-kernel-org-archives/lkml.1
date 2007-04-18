Return-Path: <linux-kernel-owner+w=401wt.eu-S2993035AbXDRTBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993035AbXDRTBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993037AbXDRTBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:01:12 -0400
Received: from pat.uio.no ([129.240.10.15]:58262 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993036AbXDRTBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:01:10 -0400
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new
	namespace" clone flag
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, ebiederm@xmission.com,
       serue@us.ibm.com, linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, containers@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070418150110.GA29815@infradead.org>
References: <20070416195652.GA350@sergelap.austin.ibm.com>
	 <m1k5wbjrsh.fsf@ebiederm.dsl.xmission.com>
	 <E1HdlYr-00015O-00@dorka.pomaz.szeredi.hu>
	 <m1zm56j27m.fsf@ebiederm.dsl.xmission.com>
	 <E1HdsX6-0002Kl-00@dorka.pomaz.szeredi.hu>
	 <m1vefuixp5.fsf@ebiederm.dsl.xmission.com>
	 <E1He6C7-0003Xu-00@dorka.pomaz.szeredi.hu>
	 <1176904505.6796.79.camel@heimdal.trondhjem.org>
	 <E1HeAkl-000490-00@dorka.pomaz.szeredi.hu>
	 <1176906389.6796.96.camel@heimdal.trondhjem.org>
	 <20070418150110.GA29815@infradead.org>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 15:00:47 -0400
Message-Id: <1176922847.6796.127.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.060)
X-UiO-Scanned: 7238BF512EC9E9EC63BCC5EB5D8C29D8E42FE73B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 51 total 1168764 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 16:01 +0100, Christoph Hellwig wrote:
> I suspect the right answer here is to make nfs mount handling smarter.
> The way mounting works the filesystem is allowed to choose whether it
> can re-used a superblock or needs a new one.  In the NFS case we probably
> want to allow multiple superblocks for the same export if important
> paramaters like the security model mismatch.

It might also be another application for layering. If I were able to
share enough of the inode and dentry information between superblocks,
then all sorts of interesting possibilities arise...

Cheers
  Trond

