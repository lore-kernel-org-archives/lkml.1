Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYEGFkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYEGFkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 01:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYEGFkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 01:40:41 -0400
Received: from ozlabs.org ([203.10.76.45]:33014 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYEGFkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 01:40:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18465.16592.41821.225568@cargo.ozlabs.ibm.com>
Date: Wed, 7 May 2008 15:40:32 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, David Miller <davem@davemloft.net>,
       tony@bakeyournoodle.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
In-Reply-To: <20080506211233.f050fd41.akpm@linux-foundation.org>
References: <20080424043400.GS20457@bakeyournoodle.com>
	<20080506143936.6357e578.akpm@linux-foundation.org>
	<20080506.144301.233784820.davem@davemloft.net>
	<20080506145608.565b61bf.akpm@linux-foundation.org>
	<20080506210055.75e2f881@infradead.org>
	<20080506211233.f050fd41.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> On Tue, 6 May 2008 21:00:55 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> > can we make it a WARN_ON() as well? that way we'll see it in various
> > kerneloops.org stats etc etc.. and we also get a nice backtrace for
> > free to go with it....
> > 
> > (rationale: users tend to not read their dmesg much, but WARN_ON()'s do
> > get noticed)
> 
> OK by me, although if we're going to do much more of this it might be time
> to add a WARN_ON which takes (fmt, args...).

It would make a lot more sense to put the printk and/or WARN_ON inside
sysfs_create_bin_file rather than in every single caller.

Paul.
