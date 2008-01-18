Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbYARVER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbYARVER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762664AbYARVD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:03:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33634 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761837AbYARVD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:03:56 -0500
Date: Fri, 18 Jan 2008 22:03:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: fix typo PAT to X86_PAT
Message-ID: <20080118210344.GC10717@elte.hu>
References: <20080118123140.GI11044@elte.hu> <20080118182437.GA10167@redhat.com> <924EFEDD5F540B4284297C4DC59F3DEE62B7BA@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE62B7BA@orsmsx423.amr.corp.intel.com>
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


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> Ingo, can you remove this PAT MTRR exclusion.

yeah, already did that.

> Actually, this exclusion will not work at all with the current code. 
> Infact it should be PAT selects MTRR, for the current code. As 
> pat_init() is called during mtrr init as the rules for how to change 
> PAT and how to change MTRR are same. Further, MTRR is always required 
> on SMP, as we read the MTRR setting from boot CPU and set it on Aps at 
> boot time. We should only remove the /proc/mtrr write permissions with 
> CONFIG_PAT. We need to deprecate it for a while before that...

ok.

	Ingo
