Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbYAVTsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbYAVTsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYAVTsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:48:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42595 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbYAVTsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:48:13 -0500
Date: Tue, 22 Jan 2008 20:47:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Eduardo Pereira Habkost <ehabkost@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com
Subject: Re: [PATCH 0/4] paravirt_ops-64 compile fixes
Message-ID: <20080122194710.GC3218@elte.hu>
References: <1200952133-31581-1-git-send-email-ehabkost@redhat.com> <20080122120207.GA30271@elte.hu> <20080122123450.GU7338@blackpad> <47962E1D.2090308@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47962E1D.2090308@goop.org>
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

>> Maybe should this force-paravirt mode be a kernel debugging option?
>
> No, just a plain CONFIG_PARAVIRT to turn it on and off independently 
> of everything else.

it should be a debugging option in the way that it's dependent on 
KERNEL_DEBUG and KERNEL_EXPERIMENTAL.

i dont think you shold worry about this - i think 64-bit guest support 
for specific hypervisors could be added even after the merge window, if 
it's reasonably isolated (which i'd expect it to be). It clearly cannot 
break anything else so it's the same category as new driver or new 
hardware support - more relaxed integration rules. Then we can remove 
the KERNEL_DEBUG and KERNEL_EXPERIMENTAL dependency as well.

	Ingo
