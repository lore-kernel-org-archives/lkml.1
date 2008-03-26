Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYCZWv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYCZWv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYCZWvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:51:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33348 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbYCZWvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:51:17 -0400
Date: Wed, 26 Mar 2008 22:51:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] vfs: mountinfo: show dominating group id
Message-ID: <20080326225112.GW10722@ZenIV.linux.org.uk>
References: <20080326211131.705321084@szeredi.hu> <20080326212144.764829833@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326212144.764829833@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 10:11:38PM +0100, Miklos Szeredi wrote:
> +static struct vfsmount *get_peer_under_root(struct vfsmount *mnt,
> +					    struct mnt_namespace *ns,

Isn't it mnt->mnt_ns in all cases?

> +int get_dominator_id_same_root(struct vfsmount *mnt, const struct path *root)

Open season for better name.  Leaving aside .au associations, it's too
long and too uninformative...   Will do for now, but we'd better come up
with something better.
