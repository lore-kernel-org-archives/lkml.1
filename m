Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbZH1Vwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbZH1Vwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZH1Vwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:52:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:52147 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbZH1Vwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:52:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,292,1249282800"; 
   d="scan'208";a="488365375"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>
Date: Fri, 28 Aug 2009 14:52:40 -0700
Subject: [RFC PATCH 0/7] x86/boot: Moorestown patch set based on
 platform_set abstraction
Thread-Topic: [RFC PATCH 0/7] x86/boot: Moorestown patch set based on
 platform_set abstraction
Thread-Index: Acoir9vx9XaYijQEQY+7z9INN3fH8AFdeJLQ
Message-ID: <43F901BD926A4E43B106BF17856F07556A5EA86F@orsmsx508.amr.corp.intel.com>
References: <20090821205008.518392436@linutronix.de>
 <20090821205601.878468441@linutronix.de> <4A8F1E4D.9080409@goop.org>
 <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on platform_setup patchset posted by tglx (http://lkml.org/lkml/2009/8/21/358)

These Moorestown patches have become much simplified once ported to the new
platform_setup layer. 

Now the platform feature flags are less useful, in fact they
are only used in separating ioapic and 8259 now, so once the interrupt
controller code is drivernized, we would not need the platform feature flags
in the core.

Thanks,

Jacob
