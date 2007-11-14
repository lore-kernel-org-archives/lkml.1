Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbXKNE0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbXKNE0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbXKNE0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:26:34 -0500
Received: from relay1.sgi.com ([192.48.171.29]:35410 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754534AbXKNE0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:26:33 -0500
Date: Tue, 13 Nov 2007 20:26:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071113.201853.40241484.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711132023290.7631@schroedinger.engr.sgi.com>
References: <20071113.031510.151440585.davem@davemloft.net>
 <p73wssly6sr.fsf@bingen.suse.de> <Pine.LNX.4.64.0711132011060.7528@schroedinger.engr.sgi.com>
 <20071113.201853.40241484.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 13 Nov 2007, David Miller wrote:

> From: Christoph Lameter <clameter@sgi.com>
> Date: Tue, 13 Nov 2007 20:15:55 -0800 (PST)
> 
> > Guess I need also to add an arch configuration guide to V2 as well so that 
> > the other arches can do similar tricks and emphasize that the static 
> > default that requires bss is only suitable for small systems.
> 
> I'm going to be against your changes until you implement
> a real fix for the BSS bloat problems.
> 
> It's worse than the per-cpu allocator we have now, much
> worse.

You need to configure cpu_alloc for your arch and so far you seem 
to not have had the time to understand how it works otherwise you would 
not repeat these statements and ask me to implement what the 
patch already provides.

The only problem that I see so far is a communication problem. Thus we 
need more documentation.
