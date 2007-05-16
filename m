Return-Path: <linux-kernel-owner+w=401wt.eu-S1763410AbXEPXlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763410AbXEPXlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbXEPXlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:41:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53540 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757511AbXEPXlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:41:00 -0400
Date: Wed, 16 May 2007 16:40:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] scalable rw_mutex
In-Reply-To: <20070516162829.23f9b1c4.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705161639010.12688@schroedinger.engr.sgi.com>
References: <20070511131541.992688403@chello.nl> <20070511132321.895740140@chello.nl>
 <20070511093108.495feb70.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705111006470.32716@schroedinger.engr.sgi.com>
 <20070511110522.ed459635.akpm@linux-foundation.org> <p73odkpeusf.fsf@bingen.suse.de>
 <20070512110624.9ac3aa44.akpm@linux-foundation.org>
 <20070516162829.23f9b1c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Andrew Morton wrote:

> (I hope.  Might have race windows in which the percpu_counter_sum() count is
> inaccurate?)

The question is how do these race windows affect the locking scheme?
