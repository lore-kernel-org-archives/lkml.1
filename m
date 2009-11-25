Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZKYLSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZKYLSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758353AbZKYLSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:18:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45927 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZKYLSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:18:52 -0500
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter
 irqbalance hints
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Yong Zhang <yong.zhang0@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <alpine.LFD.2.00.0911241027140.24119@localhost.localdomain>
References: <20091123064630.7385.30498.stgit@ppwaskie-hc2.jf.intel.com>
	 <2674af740911222332i65c0d066h79bf2c1ca1d5e4f0@mail.gmail.com>
	 <1258968980.2697.9.camel@ppwaskie-mobl2> <1258995923.4531.715.camel@laptop>
	 <Pine.WNT.4.64.0911231529240.10056@ppwaskie-MOBL2.amr.corp.intel.com>
	 <1259051902.4531.1053.camel@laptop>
	 <1259053156.2631.21.camel@ppwaskie-mobl2>
	 <alpine.LFD.2.00.0911241027140.24119@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 12:18:52 +0100
Message-ID: <1259147932.4027.327.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While we're dicking about with irq affinities, maybe we ought to
consider cpuset integration as well. There's various folks who want to
use exclusive cpusets to isolate workloads.


