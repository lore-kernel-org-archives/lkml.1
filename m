Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZFSBTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZFSBTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 21:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZFSBTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 21:19:18 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:37172 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbZFSBTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 21:19:17 -0400
Subject: Re: linux-next: nfs tree build warning
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Sager <sager@netapp.com>
In-Reply-To: <20090619105022.4dc10679.sfr@canb.auug.org.au>
References: <20090619105022.4dc10679.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 18:09:12 -0700
Message-Id: <1245373752.8756.59.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 4 sum msgs/h 1 total rcpts 724 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=_URIID_)
X-UiO-Scanned: A6E9EEB6A0601ADFEE4B4D8F06393187CC91B474
X-UiO-SPAM-Test: remote_host: 198.95.226.230 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 19 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 10:50 +1000, Stephen Rothwell wrote:
> Hi Trond,
> 
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
> 
> fs/nfs/super.c: In function 'nfs_parse_mount_options':
> fs/nfs/super.c:1253: warning: passing argument 2 of 'match_int' from incompatible pointer type
> include/linux/parser.h:29: note: expected 'int *' but argument is of type 'long unsigned int *'
> 
> Introduced by commit 3fd5be9e19921a89d9ed78d6a708a379a6c3c76a ("nfs41:
> add mount command option minorversion").
> 

That's my fault: it was due to inattention during the merge of the
nfsv41 tree with the mainline NFS changes. I'll fix...

Trond

