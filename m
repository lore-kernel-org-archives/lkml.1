Return-Path: <linux-kernel-owner+w=401wt.eu-S1161051AbXBTXIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161051AbXBTXIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161065AbXBTXIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:08:13 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:55564 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161051AbXBTXIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:08:12 -0500
Message-ID: <45DB7F55.20008@vilain.net>
Date: Wed, 21 Feb 2007 12:08:05 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.2 (X11/20060521)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, containers@lists.osdl.org, winget@google.com,
       rohitseth@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
References: <20070212081521.808338000@menage.corp.google.com>	 <45D0EC68.9090009@vilain.net>	 <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>	 <m1wt2c4ttj.fsf@ebiederm.dsl.xmission.com>	 <6599ad830702200955l10f3c71aucff1d4b815e1a1e7@mail.gmail.com>	 <m1bqjo4ogj.fsf@ebiederm.dsl.xmission.com> <6599ad830702201447t711cdf00u3704a0dac8780f91@mail.gmail.com>
In-Reply-To: <6599ad830702201447t711cdf00u3704a0dac8780f91@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
>> No. A reverse mapping is not needed and is not interesting.
>>     
> ... to you.
>   

You're missing the point of Eric's next sentence.  If you can achieve
everything you need to achieve and get all the information you are after
without it, then it is uninteresting.

>> As long as I can walk all processes and ask what namespace are
>> you in I don't care.
>>     
>
> How do you currently do that?
>   

Take a look at /proc/PID/mounts for example.

>> All that is necessary to have a group of processes do something
>> in an unnamed fashion is to hang a pointer off of the task_struct.
>> That's easy.
>>     
> Right, adding a pointer to task_struct is easy. Configuring how/when
> to not directly inherit it from the parent, or to change it for a
> running task, or configuring state associated with the thing that the
> pointer is pointing to, naming that group, and determining which group
> a given process is assocaited with, is something that's effectively
> repeated boiler plate for each different subsystem, and which can be
> accomplished more generically via an abstraction like my containers
> patch.
>   

So make helpers.  Macros.  Anything, just don't introduce model
limitations like the container structure, because we've already got the
structure; the nsproxy.

Sam.
