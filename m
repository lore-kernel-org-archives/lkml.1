Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbXGIPpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbXGIPpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbXGIPpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:45:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57643 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754102AbXGIPpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:45:44 -0400
Date: Mon, 9 Jul 2007 08:45:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       penberg@cs.helsinki.fi, akpm@linux-foundation.org
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality,
 performance and maintenance
In-Reply-To: <20070707.213752.63129539.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0707090845230.13792@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <20070707.213752.63129539.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jul 2007, David Miller wrote:

> From: Christoph Lameter <clameter@sgi.com>
> Date: Sat, 07 Jul 2007 20:49:52 -0700
> 
> > A cmpxchg is less costly than interrupt enabe/disable
> 
> This is cpu dependant, and in fact not true at all on Niagara
> and several of the cpus in the UltraSPARC family.

Hmmm... So have alternate aloc/free paths depending on the cpu?

