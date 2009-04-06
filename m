Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbZDFWSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbZDFWSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZDFWSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:18:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZDFWSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:18:43 -0400
Date: Mon, 6 Apr 2009 18:18:34 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, niv@us.ibm.com, manfred@colorfullife.com,
       peterz@infradead.org, lethal@linux-sh.org, kernel@wantstofly.org,
       andi@firstfloor.org, kyle@mcmartin.ca, deller@gmx.de,
       davem@davemloft.net, ralf@linux-mips.org, jes@sgi.com,
       benh@kernel.crashing.org, paulus@samba.org, anton@samba.org
Subject: Re: [PATCH -tip] v2: Make TREE_RCU be default (was CLASSIC_RCU).
Message-ID: <20090406221834.GA7372@bombadil.infradead.org>
References: <20090406221628.GA18232@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406221628.GA18232@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 03:16:28PM -0700, Paul E. McKenney wrote:
> Given that there have been no TREE_RCU bugs reported for some months,
> it is time to make TREE_RCU be the default RCU implementation.  The rest
> of this series updates defconfig files that: (1) have CONFIG_SMP=y and
> (2) explicitly mention CONFIG_CLASSIC_RCU.
> 
> Given that I don't have access to most of the relevant hardware, much
> of this is untested.
> 
> Changes since v1: per-arch defconfig patches dropped.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 

Do you intend to do this for .30 or .31? I'll try to test it as
soon as I can on parisc... Somehow I suspect it won't be the worst
of the problems... :)

regards, Kyle
