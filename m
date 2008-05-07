Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbYEGFuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbYEGFuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 01:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYEGFuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 01:50:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:42054 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbYEGFuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 01:50:06 -0400
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
	drivers/video/aty/radeon_base.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <18465.16592.41821.225568@cargo.ozlabs.ibm.com>
References: <20080424043400.GS20457@bakeyournoodle.com>
	 <20080506143936.6357e578.akpm@linux-foundation.org>
	 <20080506.144301.233784820.davem@davemloft.net>
	 <20080506145608.565b61bf.akpm@linux-foundation.org>
	 <20080506210055.75e2f881@infradead.org>
	 <20080506211233.f050fd41.akpm@linux-foundation.org>
	 <18465.16592.41821.225568@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 07 May 2008 15:49:07 +1000
Message-Id: <1210139347.21644.239.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 15:40 +1000, Paul Mackerras wrote:
> > > (rationale: users tend to not read their dmesg much, but
> WARN_ON()'s do
> > > get noticed)
> > 
> > OK by me, although if we're going to do much more of this it might
> be time
> > to add a WARN_ON which takes (fmt, args...).
> 
> It would make a lot more sense to put the printk and/or WARN_ON inside
> sysfs_create_bin_file rather than in every single caller.

Amen !

Ben.


