Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbYFJReU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbYFJReU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYFJReG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:34:06 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36159 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752925AbYFJReF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:34:05 -0400
Date: Tue, 10 Jun 2008 10:34:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mike Travis <travis@sgi.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 02/41] cpu alloc: The allocator
In-Reply-To: <4846AEF6.2020107@sgi.com>
Message-ID: <Pine.LNX.4.64.0806101033350.17131@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com>
 <200805301546.49627.rusty@rustcorp.com.au> <4846AEF6.2020107@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Mike Travis wrote:

> I haven't seen any further discussion on these aspects... is there a consensus
> to remove the flags from CPU_ALLOC() and use a mutex?

We want to have extensable per cpu areas. This means you need an 
allocation context. So we need to keep the flags. Mutex is not a bad idea.


