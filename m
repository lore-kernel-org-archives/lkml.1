Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbYIHSON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbYIHSON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYIHSN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:13:58 -0400
Received: from gw.goop.org ([64.81.55.164]:36151 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbYIHSN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:13:58 -0400
Message-ID: <48C56B60.8050604@goop.org>
Date: Mon, 08 Sep 2008 11:13:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rambaldi <rambaldi@xs4all.nl>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 xen balloon driver warnings
References: <48C0F09C.1000101@xs4all.nl> <48C457DC.9050904@goop.org> <20080908175906.GA29264@elte.hu>
In-Reply-To: <20080908175906.GA29264@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Rambaldi wrote:
>>     
>>> Hi,
>>>
>>> when running the 2.6.27-rc5 kernel as 64 bits dumU I get the following
>>> warnings:
>>>       
>> This patch, change 167e6cf62979df03513898966f9227847d192327 in tip.git,
>> should fix this.  I'm not sure if the other sysfs changes apply to
>> mainline git or not.
>>
>> Could you try this and see how it goes?  The first chunk should be
>> sufficient to fix your problem.
>>     
>
> We could certainly propagate it to x86/urgent, if it fixes a real issue. 
> It cherry-picks just fine.
>   

The rest of that patch updates the sysfs entries in line with Andi's
changes, but I don't think they're in mainline yet.

The sysfs namespace clash means that Xen balloon and hotplug memory try
to register the same name, which is bad because one of them is going to
lose.

    J
