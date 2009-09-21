Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbZIUQpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbZIUQpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZIUQpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:45:10 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:33739
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751369AbZIUQpI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:45:08 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432R98dN9371Pzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KQBYIX-01-0QR-02
X-M-MSG: 
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "'Rusty Russell'" <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Date: Mon, 21 Sep 2009 11:44:59 -0500
Subject: RE: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
Thread-Topic: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
Thread-Index: AcnqPTsiJSrbeUZPTcanUENrgd2sixQnMCaA
Message-ID: <DDE95BDD51FB774B804A9C029E735EE10379BEDA33@sausexmbp02.amd.com>
References: <4A2835D8.6040903@kernel.org>
 <200906101552.17397.rusty@rustcorp.com.au>
 <6453C3CB8E2B3646B0D020C1126132730362099D@sausexmb4.amd.com>
 <200906111204.48441.rusty@rustcorp.com.au>
In-Reply-To: <200906111204.48441.rusty@rustcorp.com.au>
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

> On Thu, 11 Jun 2009 05:12:16 am Langsdorf, Mark wrote:
> > > powernow_k8_target is problematic: it grabs a mutex.  cpufreq
> > > people, is this called often?
> >
> > Yes.  It's the function that makes a frequency change
> > happen, so 5+ times per second per core isn't
> > unreasonable.
> 
> Right, so we need to revisit this.  I'll leave it for the 
> moment and put it on my TODO list.

Rusty -

Did you ever get any ideas on a solution to this?  I'm
getting reports that the set_cpus_allowed_ptr() in
powernow_k8_target() is breaking with changeset
ebc79c4f8da0f92efa968e0328f32334a2ce80cf .  I haven't
changed the powernow_k8 code, so I suspect something
happened to set_cpus_allowed_ptr().

-Mark Langsdorf
Operating System Research Center
AMD
