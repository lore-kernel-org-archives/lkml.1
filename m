Return-Path: <linux-kernel-owner+w=401wt.eu-S2992519AbXCBPfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992519AbXCBPfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992521AbXCBPfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:35:17 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:47987 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992519AbXCBPfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:35:16 -0500
Message-ID: <45E84682.6040500@openvz.org>
Date: Fri, 02 Mar 2007 18:45:06 +0300
From: Kirill Korotaev <dev@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: vatsa@in.ibm.com, menage@google.com, ebiederm@xmission.com, sam@vilain.net,
       akpm@linux-foundation.org, xemul@sw.ru, serue@us.ibm.com,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
 top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com> <20070301113900.a7dace47.pj@sgi.com>
In-Reply-To: <20070301113900.a7dace47.pj@sgi.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

>>I suspect we can make cpusets also work
>>on top of this very easily.
> 
> 
> I'm skeptical, and kinda worried.
> 
> ... can you show me the code that does this?
don't worry. we are not planning to commit any code breaking cpusets...
I will be the first one against it.

> Namespaces are not the same thing as actual resources
> (memory, cpu cycles, ...).  Namespaces are fluid mappings;
> Resources are scarce commodities.
hm... interesing comparison.
as for me, I can't see much difference between virtualization namespaces
and resource namespaces.

Both have some impact on what the task in the namespace can do and what can't.
The only difference is that virtualization namespaces usually also
make one user to be invisible to another. That's the only difference imho.

Also if you take a look at IPC namespace you'll note that IPC
can also limit IPC resources in question.
So it is kinda of virtualization + resource namespace.

> I'm wagering you'll break either the semantics, and/or the
> performance, of cpusets doing this.
I like Paul's containers patch. It looks good and pretty well.
After some of the context issues are resolved it's fine.
Maybe it is even the best way of doing things.

Thanks,
Kirill

