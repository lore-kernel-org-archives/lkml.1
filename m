Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbYABUz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbYABUz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYABUzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:55:20 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34206 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752262AbYABUzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:55:19 -0500
Date: Wed, 2 Jan 2008 12:55:18 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: travis@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: [PATCH 05/10] x86_64: Use generic percpu
In-Reply-To: <200712281354.52453.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0801021254250.22538@schroedinger.engr.sgi.com>
References: <20071228001046.854702000@sgi.com> <20071228001047.556634000@sgi.com>
 <200712281354.52453.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007, Andi Kleen wrote:

> On Friday 28 December 2007 01:10:51 travis@sgi.com wrote:
> > x86_64 provides an optimized way to determine the local per cpu area
> > offset through the pda and determines the base by accessing a remote
> > pda.
> 
> And? The rationale for this patch seems to be incomplete.
> 
> As far as I can figure out you're replacing an optimized percpu 
> implementation which a dumber generic one. Which needs
> at least some description why.

The implementation stays the same. The code is just consolidated.

