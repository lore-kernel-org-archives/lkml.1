Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYATJVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYATJVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 04:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYATJUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 04:20:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55414 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbYATJUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 04:20:47 -0500
Date: Sun, 20 Jan 2008 10:20:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: update e820 instead of updating end_pfn
Message-ID: <20080120092027.GB8379@elte.hu>
References: <200801192045.17291.yinghai.lu@sun.com> <4792DE0C.9060906@zytor.com> <200801200017.24445.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801200017.24445.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_64: update e820 instead of updating end_pfn
> 
> when mtrr is not covering all e820 table, need to trim the ram, need 
> to update e820

ok, i like this approach even more - applied. Would you like to have a 
shot at adding mtrr_trim_uncached_memory() to 32-bit too? It is affected 
by the same problem (if not more).

	Ingo
