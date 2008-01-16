Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYAPSHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYAPSHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYAPSHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:07:43 -0500
Received: from relay2.sgi.com ([192.48.171.30]:59196 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751384AbYAPSHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:07:42 -0500
Date: Wed, 16 Jan 2008 10:07:36 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>, travis@sgi.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] x86: Reduce memory and intra-node effects with
 large count NR_CPUs
In-Reply-To: <200801161834.39746.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0801161006000.9061@schroedinger.engr.sgi.com>
References: <20080113183453.973425000@sgi.com> <20080114101133.GA23238@elte.hu>
 <200801141230.56403.ak@suse.de> <200801161834.39746.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008, Nick Piggin wrote:

> Oh, just while I remember it also, something funny is that MAX_NUMNODES
> can be bigger than NR_CPUS on x86. I guess one can have CPUless nodes,
> but wouldn't it make sense to have an upper bound of NR_CPUS by default?

There are special configurations that some customers want which involves 
huge amounts of memory and just a few processors. In that case the number 
of nodes becomes larger than the number of processors.

