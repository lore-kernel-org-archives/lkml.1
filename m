Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbXKAA00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbXKAA00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXKAA0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:26:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35517 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752059AbXKAA0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:26:17 -0400
Date: Wed, 31 Oct 2007 17:26:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <20071031.172421.228723187.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0710311724490.25361@schroedinger.engr.sgi.com>
References: <20071101000211.970501947@sgi.com> <20071031.172421.228723187.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, David Miller wrote:

> 
> Are these patches against -mm or mainline?
> 
> I get a lot of rejects starting with patch 6 against
> mainline and I really wanted to test them out on sparc64.

Hmmm... They are against the current slab performance head (which is in mm 
but it has not been released yet ;-).

Do 

git pull git://git.kernel.org/pub/scm/linux/kernel/git/christoph/slab.git 
performance

and then you should be able to apply these patches.

