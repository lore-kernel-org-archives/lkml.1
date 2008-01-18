Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbYARMcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbYARMcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYARMbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:31:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbYARMbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:31:52 -0500
Date: Fri, 18 Jan 2008 13:31:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: venkatesh.pallipadi@intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: fix typo PAT to X86_PAT
Message-ID: <20080118123140.GI11044@elte.hu>
References: <200801171950.32458.yinghai.lu@sun.com> <20080118081040.GB16597@elte.hu> <200801180103.37771.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801180103.37771.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> > thanks. But, i think we should rather do the following: if X86_PAT 
> > is eanbled then /proc/mtrr should be read-only. There's no problem 
> > _looking_ at MTRR contents, as long as we do not try to modify them. 
> > Hm?
> 
> anyway
> 
> depends on !PAT
> 
> need to be removed.
> 
> it seems when PAT is used, some code still touch MTRR.

you mean modifies MTRRs? Which code is that? (besides the /proc/mtrr 
userspace API)

	Ingo
