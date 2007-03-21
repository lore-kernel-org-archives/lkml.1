Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbXCUPzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbXCUPzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932529AbXCUPzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:55:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40752 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbXCUPzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:55:06 -0400
Date: Wed, 21 Mar 2007 17:55:05 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Christoph Lameter <christoph@lameter.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead
 of struct slab
In-Reply-To: <20070321164927.98256bf8.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703211752470.20159@sbz-30.cs.Helsinki.FI>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
 <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
 <Pine.LNX.4.64.0703210742080.1573@graphe.net>
 <Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
 <20070321164927.98256bf8.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Eric Dumazet wrote:
> This wont work, because of use_alien_caches knob.
> 
> If use_alien_caches is set to 0, your WARN_ON will trigger many false 
> alarms

How is that? The mapping should always be the same regardless of whether 
we use alien caches or not.
