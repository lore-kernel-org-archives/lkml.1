Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZBEXnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZBEXnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZBEXmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:42:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53558 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZBEXmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:42:51 -0500
Date: Fri, 6 Feb 2009 00:42:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       William Lee Irwin III <wli@movementarian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
Message-ID: <20090205234241.GA14203@elte.hu>
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu> <498B35F9.601@goop.org> <20090205191017.GF20470@elte.hu> <Pine.LNX.4.64.0902051921150.30938@blonde.anvils> <498B4F1F.5070306@goop.org> <Pine.LNX.4.64.0902052046240.18431@blonde.anvils> <498B54A0.7040005@goop.org> <20090205215050.GB28097@elte.hu> <498B6325.1040401@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B6325.1040401@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> We'd also lose a fair bit of performance (not to mention the pagetable  
>> footprint doubling that Hugh already mentioned) on 32-bit PAE capable  
>> systems that dont actually have RAM above 4G physical.
>
> Why's that?  Do you mean directly from using PAE, or as a side-effect of 
> highmem?

just the act of using PAE was measured to cause multi-percent slowdown in 
fork() and exec() latencies, etc. The pagetables are twice as large so is 
that really surprising?

	Ingo
