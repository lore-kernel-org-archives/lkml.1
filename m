Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbZLOMYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbZLOMYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbZLOMYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:24:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:58029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbZLOMYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:24:22 -0500
Date: Tue, 15 Dec 2009 13:24:16 +0100
From: Jan Kara <jack@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jan Kara <jack@suse.cz>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: linux-next: ext3 tree build warning
Message-ID: <20091215122415.GA5405@quack.suse.cz>
References: <20091215105925.59a66556.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215105925.59a66556.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Stephen,

On Tue 15-12-09 10:59:25, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> fs/quota/dquot.c: In function 'dquot_alloc_inode':
> fs/quota/dquot.c:1521: warning: passing argument 1 of 'mark_all_dquot_dirty' discards qualifiers from pointer target type
> fs/quota/dquot.c:327: note: expected 'struct dquot **' but argument is of type 'struct dquot * const*'
> fs/quota/dquot.c: In function 'dquot_free_inode':
> fs/quota/dquot.c:1649: warning: passing argument 1 of 'mark_all_dquot_dirty' discards qualifiers from pointer target type
> fs/quota/dquot.c:327: note: expected 'struct dquot **' but argument is of type 'struct dquot * const*'
> 
> Introduced by commit e91077e3d523c2ac2090b3447bf6244567cf7128 ("quota:
> Move duplicated code to separate functions").
  Sorry, I forgot to commit this compilation fix before pushing. It should
be fixed now.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
