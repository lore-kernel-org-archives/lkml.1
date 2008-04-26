Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbYDZOFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbYDZOFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYDZOFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:05:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56717 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbYDZOFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:05:46 -0400
Subject: Re: Announce: Semaphore-Removal tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Walker <dwalker@mvista.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20080426134430.GA28205@infradead.org>
References: <20080425170021.GH14990@parisc-linux.org>
	 <1209155917.12461.46.camel@localhost.localdomain>
	 <20080425211250.GA13858@infradead.org>
	 <1209158552.12461.53.camel@localhost.localdomain>
	 <20080426093048.GA11443@infradead.org> <1209217153.1956.14.camel@lappy>
	 <20080426134430.GA28205@infradead.org>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 16:04:34 +0200
Message-Id: <1209218674.1956.17.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-26 at 09:44 -0400, Christoph Hellwig wrote:
> On Sat, Apr 26, 2008 at 03:39:13PM +0200, Peter Zijlstra wrote:
> > I'm guessing RCU would be a bit more work?
> 
> Actually the whole XFS inode hash is gone now and replaced by a radix tree.
> As soon as nick and your work on the lockless radix trees goes in I'm
> pretty sure Dave will make use of that.

Nick's RCU radix tree is already merged - its just the speculative page
references and the rest of the lockless page-cache that is still
missing.

