Return-Path: <linux-kernel-owner+w=401wt.eu-S1767012AbXDEOil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767012AbXDEOil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767015AbXDEOil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:38:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51909 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767012AbXDEOik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:38:40 -0400
Date: Thu, 5 Apr 2007 20:16:09 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, containers@lists.osdl.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070405144609.GJ28414@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070404051526.GA16562@in.ibm.com> <6599ad830704040000of7f1197ica543e14d290509e@mail.gmail.com> <20070404172643.GA28328@in.ibm.com> <6599ad830704041957y7b81c4ecrd21f4c08b9d7c72d@mail.gmail.com> <20070405063950.GA3435@in.ibm.com> <6599ad830704042348q5675c01ep92679fb3275bafac@mail.gmail.com> <20070405084920.GB20356@in.ibm.com> <6599ad830704050229q1d4d1ef9ved0e58b93aef31ff@mail.gmail.com> <20070405124325.GA13822@in.ibm.com> <6599ad830704050713h34752b1cted9dbe1ff7ab8bec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704050713h34752b1cted9dbe1ff7ab8bec@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 07:13:37AM -0700, Paul Menage wrote:
> > ns should have a refcount of 1 to begin with.
> 
> Right - that's my point, you're effectively passing the initial
> refcount of the nsproxy to the container directory's d_fsdata
> reference.

sure ..

> > Basically I am struggling to answer "How can a zero refcount (beancounter)
> > object go non-zero when zero tasks are attached to it" ..
> 
> In that case, I think you're fine. Your last posted patches didn't
> provide a way to check for that, though, as far as I could see.

Yes, the last patch I posted is very primitive considering all the
discussions we had ..For ex: attach_task() in the last patch has more
bugs [apart from the exit race I found recently with cpusets/containers]
Each time I stopped and stared at attach_task() I could find a bug ..

-- 
Regards,
vatsa
