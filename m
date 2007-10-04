Return-Path: <linux-kernel-owner+w=401wt.eu-S1762445AbXJDWzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445AbXJDWzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 18:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760250AbXJDWzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 18:55:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759379AbXJDWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 18:55:40 -0400
Date: Thu, 4 Oct 2007 15:55:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 12/12] fuse: add blksize field to fuse_attr
Message-Id: <20071004155505.251fc64c.akpm@linux-foundation.org>
In-Reply-To: <20071002155225.855733621@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
	<20071002155225.855733621@szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 17:50:38 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Allow the userspace filesystem to supply a blksize value to be
> returned by stat() and friends.  If the field is zero, it defaults to
> the old PAGE_CACHE_SIZE value.
> 

Why does fuse need this feature?

