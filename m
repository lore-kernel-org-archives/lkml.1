Return-Path: <linux-kernel-owner+w=401wt.eu-S1751384AbXCHDch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbXCHDch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 22:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXCHDcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 22:32:36 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:57161 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbXCHDcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 22:32:35 -0500
Message-ID: <45EF83CB.9080903@vilain.net>
Date: Thu, 08 Mar 2007 16:32:27 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.2 (X11/20060521)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers
 on top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>	 <20070307205846.GB7010@sergelap.austin.ibm.com>	 <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>	 <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>	 <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>	 <45EF5A62.8000103@vilain.net>	 <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>	 <45EF5E71.7090101@vilain.net>	 <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>	 <45EF793C.1000700@vilain.net> <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com>
In-Reply-To: <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> I made sure to check [...]wikipedia.org[...] when this argument started ... :-)
>   

Wikipedia?!  That's not a referen[...]

oh bugger it.  I've vented enough today and we're on the same page now I
think.

>> This is the classic terminology problem between substance and function.
>> ie, some things share characteristics but does that mean they are the
>> same thing?
>>     
>
> Aren't you arguing my side here? My point is that what I'm trying to
> add with "containers" (or whatever name we end up using) can't easily
> be subsumed into the "namespace" concept, and you're arguing that they
> should go into nsproxy because they share some characteristics.
>   

Ok, they share this characteristic with namespaces: that they group
processes.  So, they conceptually hang off task_struct.  But we put them
on ns_proxy because we've got this vague notion that things might be
better that way.

>> about this you still insist on calling this sub-system specific stuff
>> the "container",
>>     
> Uh, no. I'm trying to call a *grouping* of processes a container.
>   

Ok, so is this going to supplant the namespaces too?

>> and then go screaming that I am wrong and you are right
>> on terminology.
>>     
>
> Actually I asked if you/Eric had better suggestions.
>   

Cool, let's review them.

Me, 07921311:38+12:
> This would suggesting re-write this patchset, part 2 as a "CPUSet
> namespace", part 4 as a "CPU scheduling namespace", parts 5 and 6 as
> "Resource Limits Namespace" (drop this "BeanCounter" brand), and of
> course part 7 falls away.
Me, 07022110:58+12:
> Did you like the names I came up with in my original reply?
>  - CPUset namespace for CPU partitioning
>  - Resource namespaces:
>    - cpusched namespace for CPU
>    - ulimit namespace for memory
>    - quota namespace for disk space
>    - io namespace for disk activity
>    - etc

Ok, there's nothing original or useful there; I'm obviously quite deliberately still punting on the issue.

Eric, 07030718:32-07:
> Pretty much.  For most of the other cases I think we are safe referring
> to them as resource controls or resource limits.    I know that roughly
> covers what cpusets and beancounters and ckrm currently do.

Let's go back in time to the thread I referred to:

Me, 06032209:08+12 and nearby posts
>  - "vserver" spelt in full
>  - family
>  - container
>  - jail
>  - task_ns (sort for namespace)
> Using the term "box" and ID term "boxid":
> create_space - creates a new space and "hashes" it

Kirill, 06032418:36+03:
> I propose to use "namespace" naming.
> 1. This is already used in fs.
> 2. This is what IMHO suites at least OpenVZ/Eric
> 3. it has good acronym "ns".

Right.  So, now I'll also throw into the mix:

  - resource groups (I get a strange feeling of déjà vú there)
  - supply chains (think supply and demand)
  - accounting classes

Do any of those sound remotely close?  If not, your turn :)

And do we bother changing IPC namespaces or let that one slide?

Sam.

