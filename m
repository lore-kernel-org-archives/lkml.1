Return-Path: <linux-kernel-owner+w=401wt.eu-S1761478AbXLMKa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478AbXLMKa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbXLMKaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:30:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48961 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753AbXLMKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:30:13 -0500
Date: Thu, 13 Dec 2007 11:29:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071213102939.GS8977@elte.hu>
References: <20071210123809.A14251@sedona.ch.intel.com> <20071210202052.GA26002@elte.hu> <029E5BE7F699594398CA44E3DDF5544401130A1E@swsmsx413.ger.corp.intel.com> <20071211145301.GA19427@elte.hu> <029E5BE7F699594398CA44E3DDF554440115D3C5@swsmsx413.ger.corp.intel.com> <20071212110330.GD1611@elte.hu> <029E5BE7F699594398CA44E3DDF554440115D6DC@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029E5BE7F699594398CA44E3DDF554440115D6DC@swsmsx413.ger.corp.intel.com>
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> Users who want to process that huge amount of data would be better off 
> using a file-based approach (well, if it cannot be held in physical 
> memory, they will spend most of their time swapping, anyway). Those 
> users would typically wait for the 'buffer full' event and drain the 
> buffer into a file - whether this is the real buffer or a bigger 
> virtual buffer.
> 
> The two-buffer approach would only benefit users who want to hold the 
> full profile in memory - or who want to stall the debuggee until they 
> processed or somehow compressed the data collected so far. Those 
> approaches would not scale for very big profiles. The small profile 
> cases would already be covered with a reasonably big real buffer.

well, the two-buffer approach would just be a general API with no 
limitations. It would make the internal buffer mostly a pure performance 
detail.

	Ingo
