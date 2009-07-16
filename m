Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbZGPSNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbZGPSNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 14:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932947AbZGPSNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 14:13:07 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:44881 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932916AbZGPSNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 14:13:02 -0400
In-Reply-To: <20090716171530.GC3576@balbir.in.ibm.com>
References: <20090708095616.cdfe8c7c.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830907131515h3c9622b5v309cf8f13d272bab@mail.gmail.com> <20090714100440.6283.A69D9226@jp.fujitsu.com> <9B7C6FE2-D946-4286-9537-C4A715997B89@embeddedalley.com> <20090716171530.GC3576@balbir.in.ibm.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <FE89F36E-EB7E-4F11-887C-5371887C7D68@embeddedalley.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Dan Malek <dan@embeddedalley.com>
Subject: Re: [PATCH 1/1] Memory usage limit notification addition to memcg
Date: Thu, 16 Jul 2009 11:16:29 -0700
To: balbir@linux.vnet.ibm.com
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 16, 2009, at 10:15 AM, Balbir Singh wrote:

> Dan, if you are suggesting that we incrementally add features, I
> completely agree with you, that way the code is reviewable and
> maintainable. As we add features we need to

Right, this is all goodness.  My specific comments are this patch
adds a new useful feature and it's been through a couple of iterations
to make it more acceptable.  Let's post it, as it makes people aware
of such a feature since it's currently in use and useful, and then
continue the discussion about how to make it (and all of the cgroup
features) better.  Otherwise, this is going to degenerate into a "do
everything but nothing gets done" ongoing discussion and I'll
quickly lose interest and move on the something else :-)

There are currently two discussions in progress.  One is about
notification limits, which this feature patch adds.  We need to
close this discussion with a more feature rich implementation
that addresses both upper and lower notification, the semantics
of this feature in a cgroup hierarchy, and in particular the
behavior outside of the memory controller group.

The second discussion is about event delivery in cgroups.
Linux already has many mechanisms, and some product
implementations patch even more of their own into the kernel.
Outside of these implementation details, we have to determine
what is useful for a cgroup.  Are events just arbitrary (anything
can send any kind of event)?  How do we pass  information?
Is there some standard header?  How do we control this so
the event target is identified and we prevent event floods?
And many more.....

> 1. Look at reuse
> 2. Make sure the design is sane and will not prohibit further
> development.

3. Contain the scope of work so I can do it without affecting
     the work that pays my salary :-)

Thanks.

	-- Dan

