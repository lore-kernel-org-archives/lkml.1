Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYHaHRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYHaHRK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 03:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYHaHQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 03:16:57 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:52044 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbYHaHQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 03:16:56 -0400
Message-ID: <48BA454F.7050308@cs.columbia.edu>
Date: Sun, 31 Aug 2008 03:16:31 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>	<Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu>	<1219437422.20559.146.camel@nimitz> <48B0F449.2000006@cs.columbia.edu>	<1219768406.8680.17.camel@nimitz> <48B49C61.1040003@cs.columbia.edu>	<1219851696.8680.67.camel@nimitz> <20080827203427.GA1158@us.ibm.com>	<1219869510.8680.90.camel@nimitz>  <20080827204853.GA4189@us.ibm.com> <1219870576.8680.96.camel@nimitz>
In-Reply-To: <1219870576.8680.96.camel@nimitz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave, Serge:

I'm currently away so I must keep this short. I think we have so far
more discussion than an actual problem. I'm happy to coordinate with
every interested party to eventually see this work go into main stream.

My only concerns are twofold: first, to get more feedback I believe we
need to get the code a bit more usable; including FDs is an excellent
way to actually do that. That will add significant value to the patch.
I think it's important to demonstrate how shared resources and multiple
processes are handled. FDs demonstrate the former (with a fixed version
of the recent patchset - I will post soon). The latter will increase
the size of the patchset significantly, so perhaps can indeed wait for
now.

It should not be hard for me to add functionality on top of a more
basic patchset. The question is, what is "basic" ?  Anyway, I will be
back towards the end of the week. Let's try to discuss this over IRC
then (e.g. Friday afternoon ?).

Oren.

Dave Hansen wrote:
> On Wed, 2008-08-27 at 15:48 -0500, Serge E. Hallyn wrote:
>> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
>>> On Wed, 2008-08-27 at 15:34 -0500, Serge E. Hallyn wrote:
>>>> (Or, is that too much effort required on your part to try and
>>>> cherrypick bits of Oren's changes back into your tree?)
>>> That would probably work as long as Oren is working on top of what I
>>> have.  It's going to be a lot harder if I have to repeat the same
>>> break-out process for each iteration of Oren's patches, though.
>>>
>> If Oren's purpose is not quite to create a upstreamable patchset,
>> then it would make more sense for him to keep a git tree and
>> put new patches on top of his existing ones (within reaason as he
>> rebases).  Then you'd at least be able to trivially look at the latest
>> deltas.
> 
> The trick would be compromising on things that I, for instance, think
> need to be rewritten or removed.
> 
> Oren would have to rebase his work against what I do.  I guess you could
> think about it like me being upstream from Oren.  Anything that I would
> change, Oren would need to rebase on top of.
> 
> Oren, are you willing to keep a set of patches that add functionality on
> top of a minimal set that I'm keeping?  Mine being the set that we're
> trying to push into mainline as soon as possible.
> 
> -- Dave
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
