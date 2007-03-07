Return-Path: <linux-kernel-owner+w=401wt.eu-S1422660AbXCGJcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422660AbXCGJcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422663AbXCGJcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:32:32 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:55635 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422660AbXCGJcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:32:31 -0500
Date: Wed, 7 Mar 2007 01:32:08 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307093208.GK18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu> <20070307085944.GA17433@wotan.suse.de> <20070307092252.GA6499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307092252.GA6499@elte.hu>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin <npiggin@suse.de> wrote:
>> After these patches, I don't think there is too much burden. The main 
>> thing left really is just the objrmap stuff, but that is just handled 
>> with a minimal 'dumb' algorithm that doesn't cost much.

On Wed, Mar 07, 2007 at 10:22:52AM +0100, Ingo Molnar wrote:
> ok. What do you think about the sys_remap_file_pages_prot() thing that 
> Paolo has done in a nicely split up form - does that complicate things 
> in any fundamental way? That is what is useful to UML.

Oracle would love it. You don't want to know how far back I've been
asked to backport that.


-- wli
