Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbXFYMuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbXFYMuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbXFYMuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:50:00 -0400
Received: from gw.goop.org ([64.81.55.164]:58603 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbXFYMt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:49:59 -0400
Message-ID: <467FB9C1.5090001@goop.org>
Date: Mon, 25 Jun 2007 08:49:05 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch, 2.6.22-rc6] fix nmi_watchdog=2 bootup hang
References: <20070605094246.GA27135@elte.hu> <20070605094555.GA28097@elte.hu> <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu> <20070610181016.GA15979@atjola.homenet> <20070618121122.GA14375@elte.hu> <20070625061819.GA21874@elte.hu> <20070625065956.GA31725@elte.hu> <20070625080521.GA24333@elte.hu> <20070625082652.GA3870@elte.hu> <20070625124512.GA5118@atjola.homenet>
In-Reply-To: <20070625124512.GA5118@atjola.homenet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink wrote:
> On 2007.06.25 10:26:52 +0200, Ingo Molnar wrote:
>   
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>     
>>> the winner is ...
>>>
>>>  f8822f42019eceed19cc6c0f985a489e17796ed8 is first bad commit
>>>  commit f8822f42019eceed19cc6c0f985a489e17796ed8
>>>  Author: Jeremy Fitzhardinge <jeremy@goop.org>
>>>  Date:   Wed May 2 19:27:14 2007 +0200
>>>
>>>     [PATCH] i386: PARAVIRT: Consistently wrap paravirt ops callsites to make them patchable
>>>       
>> and of course i'm happy to test any patch that is simpler than the 
>> brutal revert i sent.
>>     
>
> wrmsrl() looks broken, dropping the upper 32bits of the value to be
> written. Does this help?
>   

Crap.  That's embarrassing.  Does it help, because it seems likely?  
(Esp since Ingo didn't even have CONFIG_PARAVIRT enabled, so most of his 
revert would have been dead code anyway.)

    J
