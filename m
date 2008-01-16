Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbYAPXvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbYAPXvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYAPXu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:50:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYAPXu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:50:57 -0500
Date: Thu, 17 Jan 2008 00:43:39 +0100
From: Karel Zak <kzak@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
Subject: Re: [patch] VFS: extend /proc/mounts
Message-ID: <20080116234339.GG26049@petra.dvoda.cz>
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu> <20080116143051.ec488f3d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116143051.ec488f3d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 02:30:51PM -0800, Andrew Morton wrote:
> On Wed, 16 Jan 2008 23:12:31 +0100
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > In theory it could break userspace, but I think it's very unlikely to
> > do so, because stuff is added only at the end of the lines, and
> > because most programs probably parse it through the libc interface
> > which is not broken by this change.  Despite this, it should be tested
> > on as many systems as possible.
> 
> Seems like a plain bad idea to me.  There will be any number of home-made
> /proc/mounts parsers and we don't know what they do.

 So, let's use /proc/mounts_v2  ;-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
