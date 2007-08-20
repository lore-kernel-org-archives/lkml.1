Return-Path: <linux-kernel-owner+w=401wt.eu-S1765980AbXHTUi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765980AbXHTUi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762017AbXHTUcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:32:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52401 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755284AbXHTUcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:32:06 -0400
Date: Mon, 20 Aug 2007 13:32:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [patch 01/23] Fall back on interrupt disable in cmpxchg8b on
 80386 and 80486
In-Reply-To: <20070820201822.597720007@polymtl.ca>
Message-ID: <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, Mathieu Desnoyers wrote:

> already present in cmpxchg_386_u32 tells much about how this cmpxchg
> implementation should not be used in a SMP context. However, the cmpxchg_local
> can perfectly use this fallback, since it only needs to be atomic wrt the local
> cpu.

Do you have an example where the use of cmpxchg_local is a performance 
benefit when actually used in code? cmpxchg is already problematic
functionality since it is not available on all platforms.
