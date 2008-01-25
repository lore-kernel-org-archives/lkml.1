Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbYAYMSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbYAYMSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 07:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYAYMRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 07:17:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57773 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYAYMRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 07:17:51 -0500
Date: Fri, 25 Jan 2008 13:17:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080125121734.GA20442@elte.hu>
References: <20080119045918.GA12215@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119045918.GA12215@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Remove ibcs2 support in ELF loader too
> 
> ibcs2 support has never been supported on 2.6 kernels as far as I 
> know, and if it has it must have been an external patch. Anyways, if 
> anybody applies an external patch they could as well readd the ibcs 
> checking code to the ELF loader in the same patch. But there is no 
> reason to keep this code running in all Linux kernels. This will save 
> at least two strcmps each ELF execution.
> 
> No deprecation period because it could not have been used anyways.

thanks Andi, i have applied your cleanup patch to x86.git a couple of 
days ago and it (no surprise) caused no testing problems so far. (I dont 
think we need to backport this cleanup to v2.6.24.1, as iBCS2 support 
was never present in any upstream Linux kernel anyway)

	Ingo
