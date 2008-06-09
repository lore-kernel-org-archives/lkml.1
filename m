Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYFISUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYFISUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYFISUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:20:46 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49211 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754058AbYFISUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:20:45 -0400
Date: Mon, 9 Jun 2008 11:20:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86: Replace xxx_pda() operations with x86_xx_percpu().
In-Reply-To: <484D6A05.7010508@sgi.com>
Message-ID: <Pine.LNX.4.64.0806091119150.30592@schroedinger.engr.sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
 <20080604003019.711845000@polaris-admin.engr.sgi.com> <20080609130302.GA20943@elte.hu>
 <484D6A05.7010508@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paravirt support is on. We have seen an issue with that in the past. Why 
was that again?

Also check that there is really no use of the segment register before 
start_kernel() loads it. If the segment register is used to refer to pda 
stuff before start_kernel then we need to make sure that the right value 
is loaded in the asm (head64.c).


