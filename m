Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbYBIL0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbYBIL0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYBIL01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:26:27 -0500
Received: from neuf-infra-smtp-out-sp604006av.neufgp.fr ([84.96.92.121]:35460
	"EHLO neuf-infra-smtp-out-sp604006av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbYBIL00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:26:26 -0500
Message-ID: <47AD8DC6.30506@cosmosbay.com>
Date: Sat, 09 Feb 2008 12:25:58 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [git pull] more SLUB updates for 2.6.25
References: <Pine.LNX.4.64.0802071755580.7473@schroedinger.engr.sgi.com> <200802081812.22513.nickpiggin@yahoo.com.au> <47AC04CD.9090407@cosmosbay.com> <Pine.LNX.4.64.0802080008560.22689@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802080008560.22689@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Fri, 8 Feb 2008, Eric Dumazet wrote:
> 
>> And SLAB/SLUB allocators, even if only used from process context, want to
>> disable/re-enable interrupts...
> 
> Not any more..... The new fastpath does allow avoiding interrupt 
> enable/disable and we will be hopefully able to increase the scope of that 
> over time.
> 
> 

Oh, I missed this new SLUB_FASTPATH stuff (not yet in net-2.6), thanks Christoph !

