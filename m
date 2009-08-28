Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZH1TIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZH1TIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZH1TIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:08:47 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:39968 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752388AbZH1TIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:08:46 -0400
Date: Fri, 28 Aug 2009 14:43:34 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       riel@redhat.com, wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0908281441340.7317@gentwo.org>
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org> 
 <1251302598.18584.31.camel@twins>  <alpine.DEB.1.10.0908261211340.9933@gentwo.org>  <20090826180407.GA13632@elte.hu>  <alpine.DEB.1.10.0908261509580.9933@gentwo.org>  <20090826193252.GA14721@elte.hu>  <alpine.DEB.1.10.0908261627110.5554@gentwo.org> 
 <20090826135041.e6169d18.akpm@linux-foundation.org>  <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org> <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Thomas Gleixner wrote:

> You are creating a "one special case" operation mode which is not
> justified in my opinion. Let's look at the problem you want to solve:
>
>   Run exactly one thread on a dedicated CPU w/o any disturbance by the
>   scheduler tick.

Thats not the problem I want to solve. There are multiple events that
could disturb a process like timers firing, softirqs and hardirqs.

> You can move away anything else than the scheduler tick from a CPU
> today already w/o a single line of code change.

How do you remove the per processor kernel threads for allocators and
other kernel subsystems? What about IPI broadcasts?
