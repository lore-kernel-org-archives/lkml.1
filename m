Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbYFMIn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbYFMIn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 04:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYFMInT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 04:43:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525AbYFMInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 04:43:18 -0400
Date: Fri, 13 Jun 2008 01:42:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: repeatable slab corruption with LTP msgctl08
Message-Id: <20080613014234.ddd01184.akpm@linux-foundation.org>
In-Reply-To: <485230EA.2040808@bull.net>
References: <20080611221324.42270ef2.akpm@linux-foundation.org>
	<48521BC8.5080801@bull.net>
	<485230EA.2040808@bull.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 10:33:46 +0200 Nadia Derbey <Nadia.Derbey@bull.net> wrote:

> > Sorry for answering so late (I only saw you e-mail yesterday afternoon).
> > I have just run msgctl08, setting msgmni to 1722 and turning on the SLAB 
> > debug:
> > 
> > CONFIG_SLAB=y
> > CONFIG_SLABINFO=y
> > CONFIG_DEBUG_SLAB=y
> > CONFIG_DEBUG_SLAB_LEAK=y
> > 
> > kernel: linux-2.6.26-rc5-mm1
> > ltp: ltp-full-20080430
> > 
> > But I could not reproduce the bug.
> > 
> > Will try to investigate more.
> > 
> 
> Same result with 2.6.26-rc6.

erk.  It'll make me a week to bisect this.  I suppose I can plod away
at it in the background, but I won't be able to do that until the end
of this month.

> I saw from your config file that you're running a 2.6.26-rc2. Will try 
> with that one.

No, that was just when I last checked in that machine's .config file. 
It was yesterday's mainline, with that .config and `make oldconfig'.
