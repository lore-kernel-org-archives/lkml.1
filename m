Return-Path: <linux-kernel-owner+w=401wt.eu-S1030471AbXBTV6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030471AbXBTV6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030474AbXBTV6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:58:49 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:39852 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030471AbXBTV6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:58:48 -0500
Message-ID: <45DB6F07.8080409@vilain.net>
Date: Wed, 21 Feb 2007 10:58:31 +1300
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
References: <20070212081521.808338000@menage.corp.google.com>	 <45D0EC68.9090009@vilain.net>	 <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>	 <m1wt2c4ttj.fsf@ebiederm.dsl.xmission.com> <6599ad830702200955l10f3c71aucff1d4b815e1a1e7@mail.gmail.com>
In-Reply-To: <6599ad830702200955l10f3c71aucff1d4b815e1a1e7@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
>> Using the container name is bad and it led to this stupid argument.
>>
>> The fundamental unit of what we have merged into the kernel is the
>> namespace.  The aggregate of all namespaces and everything is the
>> container.
>>     
> What are you defining here as "everything"? If you mean "all things
> that could be applied to a segregated group of processes such as a
> virtual server",

The term "segregated group of processes" is too vague.  Segregated for
what?  What is the kernel supposed to do with this information?

> I guess what it comes down to, is why is an aggregation of namespaces
> suitable for the name "container", when an aggregation of namespaces
> and other resource controllers isn't?
>   

This argument goes away if you just rename these resource groups to
resource namespaces.

> What do you think might be a better name for the generic process
> groups that I'm pushing? As I said, I'm happy to do a simple
> search/replace on my code to give a different name if that turned out
> to be the gating factor to getting it merged. But I'd be inclined to
> leave that decision up to Andrew/Linus.
>   

Did you like the names I came up with in my original reply?

 - CPUset namespace for CPU partitioning
 - Resource namespaces:
   - cpusched namespace for CPU
   - ulimit namespace for memory
   - quota namespace for disk space
   - io namespace for disk activity
   - etc

>> For the case of namespaces I don't see how your code makes things
>> better.  I do not see a real problem that you are solving.
>>     
> I'm trying to solve the problem that lots of different folks
> (including us) are trying to do things that aggregate multiple process
> into some kind of constrained group, and are all trying to use
> different and incompatible ways of grouping/tracking those processes.
>   

Maybe what's missing is a set of helper macros/functions that assist
with writing new namespaces.  Perhaps you can give some more examples
and we can consider these on a case by case basis.

Sam.
