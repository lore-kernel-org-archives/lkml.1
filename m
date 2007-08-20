Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbXHTVtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbXHTVtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXHTVtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:49:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59405 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750784AbXHTVtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:49:14 -0400
Date: Mon, 20 Aug 2007 14:49:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [patch 01/23] Fall back on interrupt disable in cmpxchg8b on
 80386 and 80486
In-Reply-To: <20070820212922.GA27011@Krystal>
Message-ID: <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca>
 <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
 <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
 <20070820212922.GA27011@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, Mathieu Desnoyers wrote:

> I'm digging in the slub with cmpxchg_local patch... first detail:
> slab_alloc seems to have a return path that does not reenable
> preemption... I'll keep you posted when I finish the 2.6.23-rc2-mm2
> port.

I have a patchset here if that would help you?

