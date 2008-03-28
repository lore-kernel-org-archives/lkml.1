Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYC1JN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYC1JN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYC1JNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:13:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49053 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbYC1JNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:13:50 -0400
Date: Fri, 28 Mar 2008 10:12:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0 of 4] [RFC] hotplug memory: minor updates
Message-ID: <20080328091250.GH21413@elte.hu>
References: <patchbomb.1206664116@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1206664116@localhost>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi all,
> 
> Here's a small set of patches for memory hotplug which I needed to get 
> the Xen balloon driver working.

the x86 bits look small and trivial, so i'd suggest you get this into 
-mm to after all the other VM patches, because this seems primarily a VM 
issue.

i've applied #3 to x86.git straight away. Does #4 have dependencies on 
the other patches? I suspect it does so it cannot be applied standalone.

	Ingo
