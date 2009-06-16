Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbZFPIXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbZFPIXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZFPIXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:23:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZFPIXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:23:10 -0400
Date: Tue, 16 Jun 2009 10:23:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steve Wise <swise@opengridcomputing.com>, zygo.blaxell@xandros.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LIB: remove unmatched write_lock() in gen_pool_destroy
In-Reply-To: <20090615152959.7d4f4982.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.0906161022210.7457@wotan.suse.de>
References: <E1MGFiZ-0006oN-UW@dactyl.ottawa.xandros.ca> <alpine.LNX.2.00.0906152333080.7457@wotan.suse.de> <4A36C55F.6060002@opengridcomputing.com> <20090615152959.7d4f4982.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Andrew Morton wrote:

> > > this doesn't really qualify for trivial tree, as it introduces a 
> > > significant code change. Adding some CCs.
> > Looks ok to me.  Its dumb to aquire the lock you're gonna free anyway.  
> > Maybe some BUG_ON() that sez nobody better be holding this lock?
> CONFIG_DEBUG_OBJECTS_FREE could detect the freeing of a held rwlock. 
> But probably it hasn't been wired up to handle rwlocks.

Hmm, in fact ... am I just completely blind, or is the only user of 
CONFIG_DEBUG_OBJECTS_FREE the timer code?

-- 
Jiri Kosina
SUSE Labs
