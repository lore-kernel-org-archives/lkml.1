Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbZL1JkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbZL1JkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZL1JkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:40:15 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:59238 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZL1JkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:40:13 -0500
Date: Mon, 28 Dec 2009 10:40:03 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl, cl@linux-foundation.org
Subject: Re: lockdep possible recursive lock in slab parent->list->rlock in
 rc2
Message-ID: <20091228094003.GA7607@osiris.boeblingen.de.ibm.com>
References: <20091227120622.GA480@basil.fritz.box>
 <1261917194.5933.2.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261917194.5933.2.camel@penberg-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 02:33:14PM +0200, Pekka Enberg wrote:
> Hi Andi,
> 
> On Sun, 2009-12-27 at 13:06 +0100, Andi Kleen wrote:
> > Get this on a NFS root system while booting
> > This must be a recent change in the last week, 
> > I didn't see it in a post rc1 git* from last week
> > (I haven't done a exact bisect)
> > 
> > It's triggered by the r8169 driver close function, 
> > but looks more like a slab problem?
> > 
> > I haven't checked it in detail if the locks are 
> > really different or just lockdep not knowing 
> > enough classes.
> 
> I broke the lockdep annotations in commit
> ce79ddc8e2376a9a93c7d42daf89bfcbb9187e62 ("SLAB: Fix lockdep annotations
> for CPU hotplug"). Does this fix things for you? Heiko, the following
> patch should fix it for you too.

Works fine here too. Thanks!
