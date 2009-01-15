Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZAOSr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZAOSr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZAOSrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:47:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:41296 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbZAOSra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:47:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,271,1231142400"; 
   d="scan'208";a="422714932"
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <srostedt@redhat.com>
CC: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Date: Thu, 15 Jan 2009 11:46:50 -0700
Subject: RE: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: Acl3QP0Gjqc9hSu4QH6guhS6q/X0fwAAC7Nw
Message-ID: <CAC4B8726E86A142B27A9E9A2F2F12479D4403CE@rrsmsx505.amr.corp.intel.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
	 <20090114163557.11e097f2.akpm@linux-foundation.org>
	 <20090115012147.GW29283@parisc-linux.org>
	 <20090114180431.f4a96543.akpm@linux-foundation.org>
	 <1232028766.5966.10.camel@localhost.localdomain>
	 <20090115094442.b6394544.akpm@linux-foundation.org>
	 <20090115180052.GG29283@parisc-linux.org>
 <1232043287.21980.65.camel@localhost.localdomain>
 <496F8421.3070703@novell.com>
In-Reply-To: <496F8421.3070703@novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0FImMwM029610

Gregory Haskins [mailto:ghaskins@novell.com] wrote:
> > On Thu, 2009-01-15 at 11:00 -0700, Matthew Wilcox wrote:
> >> So if the reschedule interrupt is happening twice as often, and the
> >> context switch rate is basically unchanged, I guess that means the
> >> scheduler is doing a lot more work to get approximately the same
> >> results.  And that seems like a bad thing.
> 
> I would be very interested in gathering some data in this area.  One
> thing that pops to mind is to instrument the resched-ipi with
> ftrace_printk() and gather a trace of this system in action.  I assume
> that I wouldn't have access to this OLTP suite, so I may need a
> volunteer to try this for me.  I could put together an instrumentation
> patch for the testers convenience if they prefer.

I don't know whether Novell have an arrangement with the Well-Known Commercial Database and the Well-Known OLTP Benchmark to do runs like this.  Chinang is normally only too happy to build his own kernels with patches from people who are interested in helping, so that's probably the best way to do it.

I'm leaving for LCA in an hour or so, so further responses from me to this thread are unlikely ;-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
