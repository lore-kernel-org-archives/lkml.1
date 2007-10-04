Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbXJDFeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbXJDFeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 01:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbXJDFeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 01:34:11 -0400
Received: from uni21mr.unity.ncsu.edu ([152.1.2.137]:36234 "EHLO
	uni21mr.unity.ncsu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbXJDFeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:34:10 -0400
Message-ID: <47047B40.2020806@ncsu.edu>
Date: Thu, 04 Oct 2007 01:33:52 -0400
From: Casey Dahlin <cjdahlin@ncsu.edu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jarek Poplawski <jarkao2@o2.pl>, David Schwartz <davids@webmaster.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
References: <20071002060607.GA18588@elte.hu> <20071003080224.GB1726@ff.dom.local> <20071003081613.GA29904@elte.hu> <20071003085636.GC1726@ff.dom.local> <20071003091058.GB7802@elte.hu>
In-Reply-To: <20071003091058.GB7802@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.313940, Antispam-Data: 2007.10.3.221138
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
>   
>> [...] (Btw, in -rc8-mm2 I see new sched_slice() function which seems 
>> to return... time.)
>>     
>
> wrong again. That is a function, not a variable to be cleared.

It still gives us a target time, so could we not simply have sched_yield 
put the thread completely to sleep for the given amount of time? It 
wholly redefines the operation, and its far more expensive (now there's 
a whole new timer involved) but it might emulate the expected behavior. 
Its hideous, but so is sched_yield in the first place, so why not?

--CJD
