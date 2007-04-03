Return-Path: <linux-kernel-owner+w=401wt.eu-S1161020AbXDCRnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161020AbXDCRnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161010AbXDCRnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:43:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32864 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161020AbXDCRnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:43:41 -0400
Date: Tue, 3 Apr 2007 23:21:01 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, containers@lists.osdl.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070403175101.GN2456@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070402142727.GF2456@in.ibm.com> <m1slbiejt0.fsf@ebiederm.dsl.xmission.com> <20070403153220.GA24946@sergelap.austin.ibm.com> <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com> <20070403164615.GJ2456@in.ibm.com> <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com> <20070403171155.GK2456@in.ibm.com> <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com> <20070403173048.GL2456@in.ibm.com> <6599ad830704031030n2311bcd7hca9f34e64c66337f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704031030n2311bcd7hca9f34e64c66337f@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:30:28AM -0700, Paul Menage wrote:
> So how do you implement something like the /proc/<PID>/container info
> file in my patches? 

I havent implemented that yet, so I will look at your next question:

> (Or more generally, tell which container a task is
> in for a given hierarchy?)

Why is the hierarchy bit important here? Usually controllers need to
know "tell me what cpuset this task belongs to", which is answered
by tsk->nsproxy->ctlr_data[CPUSET_ID].

The only usecase of storing hierarchy I have found is in container_clone()
where you need to create a directory in the right hierarchy, so knowing
the hierarchy to which a controller is bound becomes important.

-- 
Regards,
vatsa
