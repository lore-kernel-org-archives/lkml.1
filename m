Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYA3A7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYA3A7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYA3A7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:59:15 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:57094
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbYA3A7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:59:14 -0500
Date: Wed, 30 Jan 2008 01:59:12 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080130005912.GC7233@v2.random>
References: <20080128202923.849058104@sgi.com> <20080129162004.GL7233@v2.random> <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com> <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com> <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com> <20080130000039.GA7233@v2.random> <20080130000559.GB7233@v2.random> <Pine.LNX.4.64.0801291621380.28027@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801291621380.28027@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 04:22:46PM -0800, Christoph Lameter wrote:
> That is only partially true. pte are created wronly in order to track 
> dirty state these days. The first write will lead to a fault that switches 
> the pte to writable. When the page undergoes writeback the page again 
> becomes write protected. Thus our need to effectively deal with 
> page_mkclean.

Well I was talking about anonymous memory.
