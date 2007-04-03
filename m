Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbXDCQUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbXDCQUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbXDCQUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:20:14 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:40318 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbXDCQUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:20:12 -0400
Message-ID: <46128021.90605@sw.ru>
Date: Tue, 03 Apr 2007 20:26:09 +0400
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, vatsa@in.ibm.com,
       akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, xemul@sw.ru,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface
 to nsproxy subsystem
References: <20070212081521.808338000@menage.corp.google.com>	 <20070212085105.170265000@menage.corp.google.com>	 <20070331024722.GA808@in.ibm.com>	 <20070402140938.GF17710@sergelap.austin.ibm.com>	 <20070402142727.GF2456@in.ibm.com>	 <m1slbiejt0.fsf@ebiederm.dsl.xmission.com>	 <20070403153220.GA24946@sergelap.austin.ibm.com> <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
In-Reply-To: <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 4/3/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
>>But frankly I don't know where we stand right now wrt the containers
>>patches.  Do most people want to go with Vatsa's latest version moving
>>containers into nsproxy?  Has any other development been going on?
>>Paul, have you made any updates?
> 
> 
> I've not made major changes since the last patch post, just some small
> optimizations and fixes - I've been too tied up with other stuff.
> 
> Whilst I've got no objection in general to using nsproxy rather than
> the container_group object that I introduced in my latest patches, I
> think that Vatsa's approach of losing the general container object is
> flawed, since it loses any kind of per-group generic state (e.g. "this
> container is being deleted") and last time I saw it, I think it would
> tend to lose processes so that they didn't show up in any directory in
> the container fs.

Sounds reasonable.
Pavel is preparing new RSS patches on top of your patches
which take into account other comments and Andrew objections.
Can we cooperate to send it altogher then?

Thanks,
Kirill
