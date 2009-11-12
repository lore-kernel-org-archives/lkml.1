Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbZKLPcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbZKLPcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZKLPcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:32:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:48494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZKLPcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:32:13 -0500
Message-ID: <4AFC2A17.9030706@kernel.org>
Date: Fri, 13 Nov 2009 00:30:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
References: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu> <4AF9C402.9040800@kernel.org> <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain> <4AFA35CB.5030801@kernel.org> <20091111113147.GB7487@elte.hu> <4AFAAC32.4020104@kernel.org> <20091111195751.GA13574@elte.hu> <4AFBDF43.3010703@kernel.org> <20091112103639.GB24684@elte.hu> <4AFBEA4B.4070100@kernel.org> <alpine.LFD.2.01.0911120714260.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911120714260.31845@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/13/2009 12:17 AM, Linus Torvalds wrote:
> On Thu, 12 Nov 2009, Tejun Heo wrote:
>> 11/12/2009 07:36 PM, Ingo Molnar wrote:
>>> Breaking strings mid-sentence is something we try not to do. (If you 
>>> know about places that do it 'quite often' then those places need fixing 
>>> too.)
>>
>> Oh... I do that all the time and I see a lot of them around too.
> 
> I hate them. I do greps for error messages, and it's annoying as hell if 
> it's hard to find.
> 
> 'checkpatch' is the major reason for them, but I think we've fixed 
> checkpath long ago to not warn about long lines if they are due to a long 
> string.
> 
> Strings should basically be broken up only at '\n' characters, so
> 
> 	printk("This is a made-up example.\n"
> 		"Ok like this\n");
> 
> is fine, because you can expect to grep for "made-up example", but not 
> over the newline.

If the consensus is to allow long string literals to overrun 80 column
limit, I have no objection.  It makes code slightly more difficult to
read for some people but well we can't make everyone happy.

Thanks.

-- 
tejun
