Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052Ab0A2Q0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab0A2Q0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708Ab0A2Q02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:26:28 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:41906 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab0A2Q01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:26:27 -0500
Message-ID: <4B630C27.1060405@austin.ibm.com>
Date: Fri, 29 Jan 2010 10:26:15 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Gabriel Paubert <paubert@iram.es>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCHv3 2/2] powerpc: implement arch_scale_smt_power for	Power7
References: <1264017638.5717.121.camel@jschopp-laptop> <1264017847.5717.132.camel@jschopp-laptop> <1264548495.12239.56.camel@jschopp-laptop> <1264720855.9660.22.camel@jschopp-laptop> <20100129122536.GA11156@iram.es>
In-Reply-To: <20100129122536.GA11156@iram.es>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel Paubert wrote:
> On Thu, Jan 28, 2010 at 05:20:55PM -0600, Joel Schopp wrote:
>   
>> On Power7 processors running in SMT4 mode with 2, 3, or 4 idle threads 
>> there is performance benefit to idling the higher numbered threads in
>> the core.  
>>
>>     
>
> Really 2, 3, or 4? When you have 4 idle threads out of 4, performance
> becomes a minor concern, no? ;-)
>
> 	Gabriel
>   
Yes, but going from 4 idle to 3 idle you want to keep the slanted 
weights.  If you ignored 4 you'd place wrong and then correct it after 
the fact.
