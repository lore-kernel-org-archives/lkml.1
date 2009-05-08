Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbZEHLuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbZEHLuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZEHLuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:50:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbZEHLuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:50:08 -0400
Date: Fri, 8 May 2009 13:49:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Matt Mackall <mpm@selenic.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 8/8] pagemap: export PG_hwpoison
Message-ID: <20090508114936.GC17129@elte.hu>
References: <20090508105320.316173813@intel.com> <20090508111032.121067794@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508111032.121067794@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wu Fengguang <fengguang.wu@intel.com> wrote:

> This flag indicates a hardware detected memory corruption on the 
> page. Any future access of the page data may bring down the 
> machine.

NAK on this whole idea, it's utterly harmful. At _minimum_ 
/proc/kpageflags should be moved to /debug/vm/ to not have
any ABI bindings.

	Ingo
