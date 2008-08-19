Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYHSX66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYHSX66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYHSX6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:58:49 -0400
Received: from gw.goop.org ([64.81.55.164]:49619 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbYHSX6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:58:49 -0400
Message-ID: <48AB5E36.8030400@goop.org>
Date: Tue, 19 Aug 2008 16:58:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Scott Wood <scottwood@freescale.com>,
       Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
References: <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal>	 <48A9AFA7.8080508@freescale.com>	 <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>	 <1219110814.8062.2.camel@pasglop>	 <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>	 <1219113549.8062.13.camel@pasglop>	 <alpine.DEB.1.10.0808182240330.13401@gandalf.stny.rr.com>	 <20080819024707.GA22659@Krystal>	 <alpine.DEB.1.10.0808191247001.28232@gandalf.stny.rr.com>	 <20080819173453.GA28239@Krystal> <1219182471.7826.16.camel@pasglop>
In-Reply-To: <1219182471.7826.16.camel@pasglop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
>> Ok, there are two cases where it's ok :
>>
>> 1 - in stop_machine, considering we are not touching code executed in
>> NMI handlers.
>> 2 - when using my replace_instruction_safe() which uses a temporary
>> breakpoint when doing the instruction replacement.
>>
>> In those cases you could use text_poke_early().
>>     
>
> Note that vmap/vunmap will be very slow.
>   

Don't we have Nick's speedups now?

    J
