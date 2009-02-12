Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbZBLCj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbZBLCj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbZBLCjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:39:47 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55348 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483AbZBLCjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:39:46 -0500
Message-ID: <49938BE6.1000402@jp.fujitsu.com>
Date: Thu, 12 Feb 2009 11:39:34 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Mike Travis <travis@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 0/8] git pull request for tip/tracing/core
References: <20090208054955.777429253@goodmis.org> <20090209093751.GD7930@elte.hu> <20090211153650.GA19576@elte.hu> <alpine.DEB.1.10.0902111147450.15438@gandalf.stny.rr.com> <alpine.DEB.1.10.0902111158380.15438@gandalf.stny.rr.com> <20090211171622.GA13239@elte.hu> <alpine.DEB.1.10.0902111227570.15438@gandalf.stny.rr.com> <20090211173131.GA27546@elte.hu> <57C9024A16AD2D4C97DC78E552063EA361689C3B@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA361689C3B@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
>>> Before we go and make the change, Peter brought up a good point on IRC. Is
>>> there any reason that ia64 needs 1 << 14 IRQs?  That's 16384!
>>>
>>> Perhaps the better solution wolud be (if possible), to simply lower the
>>> number of bits.
>> i'm the wrong person to be asked about that. (Cc:-ed the right people)
> 
> People build some pretty big systems on ia64.  SGI's largest has 4096
> cpus ... so 16384 IRQs is only 4 per cpu.  That doesn't sound like very
> many to me.
> 
> Fujitsu added the vector domain support for ia64 to get around the shortage
> of IRQs for large machines.  Added them to the Cc: list to see if they have
> comments on how many IRQs are needed.
> 

The 1024 IRQs are enough for GSIs on our maximum configuration. But
if the devices are MSI/MSI-X capable, it could be more than 1024. 

Thanks,
Kenji Kaneshige


