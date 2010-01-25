Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567Ab0AYRvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0AYRvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549Ab0AYRvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:51:08 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:52692 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0AYRvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:51:05 -0500
Message-ID: <4B5DD9F1.2010002@austin.ibm.com>
Date: Mon, 25 Jan 2010 11:50:41 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, linuxppc-dev@lists.ozlabs.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] powerpc: implement arch_scale_smt_power for Power7
References: <1264017638.5717.121.camel@jschopp-laptop>	 <1264017847.5717.132.camel@jschopp-laptop> <26556.1264021443@neuling.org>	 <4B577F1A.9060907@austin.ibm.com> <1264302028.3601.36.camel@pasglop>
In-Reply-To: <1264302028.3601.36.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Wed, 2010-01-20 at 16:09 -0600, Joel Schopp wrote:
>   
>> I can turn that into a conditional branch (case statement) with a shift 
>> for the common 1,2,4 cases which should cover all procs available today 
>> falling back to a divide for any theoretical future processors that do 
>> other numbers of threads. 
>>     
>
> Look at the cputhreads.h implementation ... Today we only support
> power-of-two numbers of threads.
>   
I've run 3 threads using cpu hotplug to offline 1 of the 4.  It's 
certainly a stupid idea, but there you go.
