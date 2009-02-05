Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbZBEQGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbZBEQGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757077AbZBEQGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:06:12 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:57779 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbZBEQGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:06:10 -0500
Message-ID: <498B0E67.8050402@linux.vnet.ibm.com>
Date: Thu, 05 Feb 2009 14:05:59 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080722)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/7] integrity
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com> <alpine.LRH.1.10.0902051013430.4638@tundra.namei.org> <1233794297.2962.7.camel@localhost.localdomain> <alpine.LRH.1.10.0902051159560.5539@tundra.namei.org> <1233803196.3574.3.camel@localhost.localdomain> <alpine.LRH.1.10.0902052010580.7359@tundra.namei.org>
In-Reply-To: <alpine.LRH.1.10.0902052010580.7359@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Wed, 4 Feb 2009, Mimi Zohar wrote:
>
>   
>> On Thu, 2009-02-05 at 12:00 +1100, James Morris wrote:
>>     
>>> On Wed, 4 Feb 2009, Mimi Zohar wrote:
>>>
>>>       
>>>> On Thu, 2009-02-05 at 10:16 +1100, James Morris wrote:
>>>>         
>>>>> I get an oops on boot with this.
>>>>>
>>>>> Do you have lock and list debugging enabled?
>>>>>           
>>>> In the past I had them enabled.  Just recompiled now with them enabled
>>>> and was able to boot without problems.
>>>>         
>>> Do you have CONFIG_PREEMPT_RCU and SMP ?
>>>       
>> I've recompiled with both CONFIG_PREEMPT_RCU and SMP and didn't
>> get the oops.  Is your TPM enabled? 
>>     
>
> It was disabled in bios, and the system boots ok with it enabled.
>
>   
Hi James, I've just submitted the fix.

Thanks,
Rajiv Andrade
IBM LTC Security Dev.

