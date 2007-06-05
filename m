Return-Path: <linux-kernel-owner+w=401wt.eu-S1765516AbXFETqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765516AbXFETqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761801AbXFETqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:46:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33346 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762644AbXFETqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:46:22 -0400
Date: Tue, 5 Jun 2007 12:46:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       Ollie Wild <aaw@google.com>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/4] mm: move_page_tables{,_up}
In-Reply-To: <20070605151203.738393000@chello.nl>
Message-ID: <Pine.LNX.4.64.0706051244010.3432@schroedinger.engr.sgi.com>
References: <20070605150523.786600000@chello.nl> <20070605151203.738393000@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Peter Zijlstra wrote:

> Provide functions for moving page tables upwards.

Could you make this more general so that it allows arbitrary page table 
pages moving? That would be useful for Mel's memory defragmentation since 
it increases the types of pages that can be moved.
