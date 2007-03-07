Return-Path: <linux-kernel-owner+w=401wt.eu-S1422696AbXCGJuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422696AbXCGJuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422699AbXCGJuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:50:39 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11132 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422696AbXCGJuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:50:37 -0500
Date: Wed, 7 Mar 2007 01:50:16 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bill Irwin <bill.irwin@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307095016.GN18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu> <20070307085944.GA17433@wotan.suse.de> <20070307092252.GA6499@elte.hu> <20070307093208.GK18774@holomorphy.com> <20070307093518.GB8424@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307093518.GB8424@elte.hu>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 10:22:52AM +0100, Ingo Molnar wrote:
>>> ok. What do you think about the sys_remap_file_pages_prot() thing that 
>>> Paolo has done in a nicely split up form - does that complicate things 
>>> in any fundamental way? That is what is useful to UML.

* Bill Irwin <bill.irwin@oracle.com> wrote:
>> Oracle would love it. You don't want to know how far back I've been 
>> asked to backport that.

On Wed, Mar 07, 2007 at 10:35:18AM +0100, Ingo Molnar wrote:
> ok, cool! Then the first step would be for you to talk to Paolo and to 
> pick up the patches, review them, nurse it in -mm, etc. Suffering in 
> silence is just a pointless act of masochism, not an efficient 
> upstream-merge tactic ;-)

It was intended for use in a debugging mode for the database, so given
the general mood where fighting backouts was an issue, I was relatively
loath to bring it up. With UML behind it I don't feel that's as much of
a concern.


-- wli
