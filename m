Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbYB1AKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbYB1AKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757728AbYB1AKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:10:10 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34062 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757392AbYB1AKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:10:09 -0500
Date: Wed, 27 Feb 2008 16:10:08 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: akpm@linux-foundation.org, Andrea Arcangeli <andrea@qumranet.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <Pine.LNX.4.64.0802271424390.13186@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0802271608500.15667@schroedinger.engr.sgi.com>
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com>
 <200802201008.49933.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0802271424390.13186@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Christoph Lameter wrote:

> Could you be specific? This refers to page migration? Hmmm... Guess we 
> would need to inc the refcount there instead?

Argh. No its the callback list scanning. Yuck. No one noticed.

