Return-Path: <linux-kernel-owner+w=401wt.eu-S1762410AbXEKRH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762410AbXEKRH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbXEKRHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:07:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55314 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757977AbXEKRHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:07:19 -0400
Date: Fri, 11 May 2007 10:07:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] scalable rw_mutex
In-Reply-To: <20070511093108.495feb70.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705111006470.32716@schroedinger.engr.sgi.com>
References: <20070511131541.992688403@chello.nl> <20070511132321.895740140@chello.nl>
 <20070511093108.495feb70.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Andrew Morton wrote:

> yipes.  percpu_counter_sum() is expensive.

Capable of triggering NMI watchdog on 4096+ processors?

