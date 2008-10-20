Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYJTWcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYJTWcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYJTWcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:32:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36309 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYJTWcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:32:10 -0400
Message-ID: <48FD0633.70604@zytor.com>
Date: Mon, 20 Oct 2008 15:29:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: john stultz <johnstul@us.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Luck, Tony" <tony.luck@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
References: <20081016232729.699004293@polymtl.ca>  <20081016234657.837704867@polymtl.ca>  <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org>  <20081017012835.GA30195@Krystal>  <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>  <20081017172515.GA9639@goodmis.org>  <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com>  <20081017184215.GB9874@Krystal>  <alpine.LFD.2.00.0810201256350.3518@nehalem.linux-foundation.org> <1f1b08da0810201438g6a109af5i75b34841462b655d@mail.gmail.com> <alpine.LFD.2.00.0810201451190.3287@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810201451190.3287@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> But it's not going to solve the "hey, I have 512 CPU's, they are all on 
> different boards, and no, they are _not_ synchronized to one global 
> clock!".
> 
> That's why I'd suggest making _purely_ local time, and then aiming for 
> something NTP-like. But maybe there are better solutions out there.
> 

At the same time, it would definitely be nice to encourage vendors of 
large SMP systems to provide a common root crystal (frequency standard) 
for a single SMP domain.  Preferrably a really good one, TCXO or better.

	-hpa
