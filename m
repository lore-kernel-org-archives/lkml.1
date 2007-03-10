Return-Path: <linux-kernel-owner+w=401wt.eu-S933430AbXCJIxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbXCJIxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933449AbXCJIxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:53:10 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:48173 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430AbXCJIxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:53:02 -0500
Message-ID: <45F271D3.3040909@vilain.net>
Date: Sat, 10 Mar 2007 21:52:35 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.4 (X11/20060615)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
Cc: menage@google.com, ebiederm@xmission.com, serue@us.ibm.com,
       vatsa@in.ibm.com, akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
 top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>	<6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>	<20070307173031.GC2336@in.ibm.com>	<20070307174346.GA19521@sergelap.austin.ibm.com>	<20070307180055.GC17151@in.ibm.com>	<20070307205846.GB7010@sergelap.austin.ibm.com>	<6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>	<m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>	<6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>	<45EF5A62.8000103@vilain.net>	<6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>	<45EF5E71.7090101@vilain.net> <20070308202713.34de89ed.pj@sgi.com>
In-Reply-To: <20070308202713.34de89ed.pj@sgi.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
>> But "namespace" has well-established historical semantics too - a way
>> of changing the mappings of local * to global objects. This
>> accurately describes things liek resource controllers, cpusets, resource
>> monitoring, etc.
>>     
>
> No!
>
> Cpusets don't rename or change the mapping of objects.
>
> I suspect you seriously misunderstand cpusets and are trying to cram them
> into a 'namespace' remapping role into which they don't fit.
>   

Look, you're absolutely right, I'm stretching the terms much too far.

namespaces implies some kind of domain, which is the namespace, and
entities within the domain, which are the names, and there is a (task,
domain) mapping. I was thinking that this implies all similar (task,
domain) mappings could be treated in the same way. But when you apply
this to something like cpusets, it gets a little abstract. Like the
entities are (task,cpu) pairs and the domains the set of cpus that a
process can run on.

Sam.
