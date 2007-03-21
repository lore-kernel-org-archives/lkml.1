Return-Path: <linux-kernel-owner+w=401wt.eu-S932489AbXCUP60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbXCUP60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXCUP60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:58:26 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:34440 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbXCUP6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:58:25 -0400
Date: Wed, 21 Mar 2007 16:58:27 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Christoph Lameter <christoph@lameter.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead
 of struct slab
Message-Id: <20070321165827.ca214c02.dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0703210844300.3160@graphe.net>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0703210737400.1573@graphe.net>
	<20070321163635.82697f08.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0703210844300.3160@graphe.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 08:44:53 -0700 (PDT)
Christoph Lameter <christoph@lameter.com> wrote:
> You wanted to exploit that MAX_NUMNODES <= 64?

Maybe my english is not perfect. I promise I improve it eventually.

My patch was for unlucky guys that have MAX_NUMNODES <= 64.

For others, the preprocessor gave the old code.
