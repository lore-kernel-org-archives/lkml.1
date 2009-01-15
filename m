Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbZAOVyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbZAOVyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932626AbZAOVy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:54:29 -0500
Received: from relay3.sgi.com ([192.48.171.31]:33558 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753984AbZAOVy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:54:28 -0500
Message-ID: <496FB092.7000400@sgi.com>
Date: Thu, 15 Jan 2009 13:54:26 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dieter Ries <clip2@gmx.de>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <496F9604.8020101@sgi.com> <496FA4B6.3000607@gmx.de>
In-Reply-To: <496FA4B6.3000607@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dieter Ries wrote:
> Mike Travis schrieb:
>> Hi Dieter and Maciej,
> 
> Hi Mike,
> 
>> Can you try the attached patches on your system?  It boots on my system fine
>> now, but wasn't there a problem with resume as well?  (My test systems are
>> remote so suspending/resuming over the network is iffy.)
> 
> I just tested it. The kernel does boot up, suspending to ram works
> perfectly, hibernating did also work, but I found an inconsistent lock
> state in dmesg afterwards. System is still fully functional
> 
> May or may not be related, I don't know.

If it doesn't happen before my patch, then it's probably related.

> 
> But the original problem is solved by your patches. Thank you!
> 
...
> 
>> The patches apply to the latest tip/cpus4096 branch:
>>
>> 	http://people.redhat.com/mingo/tip.git/README
> 
> Thanks for that link. Could one of you hint me to some documentation
> about what tip is? I searched a bit, but didn't find it.

Ingo can probably explain it more fully, I just think of it as the
"tip of the iceberg" (that sank the Titanic... ;-)

> 
>> (They may apply to linux-next as well, I'm not sure.)
>>
>> Thanks!
>> Mike
>>
> 
> cu
> 
> Dieter

