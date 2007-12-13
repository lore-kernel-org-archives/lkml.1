Return-Path: <linux-kernel-owner+w=401wt.eu-S934027AbXLMWEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027AbXLMWEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933931AbXLMWDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:03:41 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47687 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933926AbXLMWDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:03:40 -0500
Date: Thu, 13 Dec 2007 14:03:39 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
 [2.6.24-rc4-git5: Reported regressions from 2.6.23]
In-Reply-To: <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712131403170.25120@schroedinger.engr.sgi.com>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu>
 <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007, Linus Torvalds wrote:

> On that note, shouldn't we also do this for slub.c? Christoph?

SLUB does not pass __GFP_ZERO to the page allocator.
