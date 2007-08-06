Return-Path: <linux-kernel-owner+w=401wt.eu-S1764035AbXHFS7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764035AbXHFS7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXHFS7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:59:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44394 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbXHFS73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:59:29 -0400
Date: Mon, 6 Aug 2007 20:59:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <clameter@sgi.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 03/10] mm: tag reseve pages
Message-ID: <20070806185926.GB22499@one.firstfloor.org>
References: <20070806102922.907530000@chello.nl> <20070806103658.356795000@chello.nl> <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com> <p73r6mglaog.fsf@bingen.suse.de> <Pine.LNX.4.64.0708061143050.3152@schroedinger.engr.sgi.com> <1186426079.11797.88.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186426079.11797.88.camel@lappy>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> precious page flag

I always cringe when I hear that. It's really more than node/sparsemem
use too many bits. If we get rid of 32bit NUMA that problem would be
gone for the node at least because it could be moved into the mostly
unused upper 32bit part on 64bit architectures.

The alternative would be to investigate again what it does to the
kernel to just use different lookup methods for this.

-Andi
