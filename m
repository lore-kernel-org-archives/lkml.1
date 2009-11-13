Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZKMID5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZKMID5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbZKMIDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:03:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43233 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbZKMIDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:03:52 -0500
Date: Fri, 13 Nov 2009 09:03:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Andi Kleen <ak@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
Message-ID: <20091113080312.GA18054@elte.hu>
References: <20091023233746.128967000@alcatraz.americas.sgi.com>
 <87tyxmy6x6.fsf@basil.nowhere.org>
 <4AE5E48F.6020408@sgi.com>
 <20091026215544.GA3355@basil.fritz.box>
 <4AEB3D95.50300@sgi.com>
 <4AEEBE65.3070202@linux.intel.com>
 <4AEF3143.2030701@sgi.com>
 <20091112222200.GA19109@redhat.com>
 <4AFC92DD.3020105@zytor.com>
 <20091112231542.GA7129@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112231542.GA7129@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> In which case..
> 
> 	Dave
> 
> --- 
> 
> Remove the CPU cache size printk's.
> 
> They aren't useful, and pollute the dmesg output a lot (especially on 
> machines with many cores). Also the same information can be trivially 
> found out from userspace.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Precisely - these are the kind of simple patches i'd like to see.

	Ingo
