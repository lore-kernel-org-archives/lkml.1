Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZFOWbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZFOWbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZFOWbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:31:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbZFOWbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:31:13 -0400
Date: Mon, 15 Jun 2009 15:29:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steve Wise <swise@opengridcomputing.com>
Cc: trivial@kernel.org, zygo.blaxell@xandros.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LIB: remove unmatched write_lock() in gen_pool_destroy
Message-Id: <20090615152959.7d4f4982.akpm@linux-foundation.org>
In-Reply-To: <4A36C55F.6060002@opengridcomputing.com>
References: <E1MGFiZ-0006oN-UW@dactyl.ottawa.xandros.ca>
	<alpine.LNX.2.00.0906152333080.7457@wotan.suse.de>
	<4A36C55F.6060002@opengridcomputing.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 17:04:15 -0500
Steve Wise <swise@opengridcomputing.com> wrote:

> > this doesn't really qualify for trivial tree, as it introduces a 
> > significant code change. Adding some CCs.
> >
> >   
> 
> Looks ok to me.  Its dumb to aquire the lock you're gonna free anyway.  
> Maybe some BUG_ON() that sez nobody better be holding this lock?

CONFIG_DEBUG_OBJECTS_FREE could detect the freeing of a held rwlock. 
But probably it hasn't been wired up to handle rwlocks.

