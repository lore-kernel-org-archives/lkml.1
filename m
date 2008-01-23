Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbYAWTtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbYAWTtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYAWTst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:48:49 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33702 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751379AbYAWTst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:48:49 -0500
Date: Wed, 23 Jan 2008 11:48:43 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
In-Reply-To: <20080123120446.GF15848@v2.random>
Message-ID: <Pine.LNX.4.64.0801231147370.13547@schroedinger.engr.sgi.com>
References: <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random>
 <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random>
 <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com>
 <20080122223139.GD15848@v2.random> <Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com>
 <479716AD.5070708@qumranet.com> <20080123105246.GG26420@sgi.com>
 <20080123120446.GF15848@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008, Andrea Arcangeli wrote:

> On Wed, Jan 23, 2008 at 04:52:47AM -0600, Robin Holt wrote:
> > But 100 callouts holding spinlocks will not work for our implementation
> > and even if the callouts are made with spinlocks released, we would very
> > strongly prefer a single callout which messages the range to the other
> > side.
> 
> But you take the physical address and turn into mm+va with your rmap...

The remote mm+va or a local mm+va?

