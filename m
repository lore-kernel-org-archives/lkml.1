Return-Path: <linux-kernel-owner+w=401wt.eu-S1751128AbZCaJRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128AbZCaJRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZCaJRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:17:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48280 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZCaJRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:17:35 -0400
Date: Tue, 31 Mar 2009 10:16:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] : Code cleanup for fs/inode.c as per checkpatch.pl
Message-ID: <20090331091653.GU28946@ZenIV.linux.org.uk>
References: <ea11fea30903222039r4bec470crfd9825e37a926d56@mail.gmail.com> <20090330163619.d08ba85e.akpm@linux-foundation.org> <ea11fea30903301943m34a04f08hc4251c6a6039e97@mail.gmail.com> <20090331060423.GR28946@ZenIV.linux.org.uk> <ea11fea30903310202i738c1f05y754ea0a1a56574eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea11fea30903310202i738c1f05y754ea0a1a56574eb@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 02:32:37PM +0530, Manish Katiyar wrote:

> -static struct inode * find_inode(struct super_block * sb, struct hlist_head *head, int (*test)(struct inode *, void *), void *data)
> +static struct inode *find_inode(struct super_block *sb, struct hlist_head *head,
> +				int (*test)(struct inode *, void *), void *data)

If you are splitting it, split it all the way, esp. the last line.

> -static struct inode * get_new_inode(struct super_block *sb, struct hlist_head *head, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *data)
> +static struct inode *get_new_inode(struct super_block *sb,
> +				struct hlist_head *head,
> +				int (*test)(struct inode *, void *),
> +				int (*set)(struct inode *, void *), void *data)

Ditto, and that's even more serious case - here 'void *data' part is
really obfuscated.
