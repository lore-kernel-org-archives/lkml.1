Return-Path: <linux-kernel-owner+w=401wt.eu-S933608AbZIDOvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbZIDOvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932415AbZIDOvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:51:31 -0400
Received: from fifo99.com ([67.223.236.141]:52688 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351AbZIDOvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:51:31 -0400
Subject: Re: [patch 16/33] fs: dcache per-bucket dcache hash locking
From: Daniel Walker <dwalker@fifo99.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090904065536.424606052@nick.local0.net>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065536.424606052@nick.local0.net>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 07:51:37 -0700
Message-Id: <1252075897.22928.23.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 16:51 +1000, npiggin@suse.de wrote:
> +/* This should be called _only_ with a lock pinning the dentry */
> +static inline struct dentry * __dget_locked_dlock(struct dentry
> *dentry)
> +{
> +       dentry->d_count++;
> +       dentry_lru_del_init(dentry);
> +       return dentry;
> +}
> +
> +static inline struct dentry * __dget_locked(struct dentry *dentry)
> +{

Could you run your series through checkpatch, and clean up at least any
errors you find.. Plus add your signed off, most (all?) aren't signed
off..

Daniel

