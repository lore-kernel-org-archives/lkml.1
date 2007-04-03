Return-Path: <linux-kernel-owner+w=401wt.eu-S965918AbXDCRXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965918AbXDCRXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965934AbXDCRXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:23:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49362 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965918AbXDCRXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:23:24 -0400
Date: Tue, 3 Apr 2007 23:00:48 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070403173048.GL2456@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070331024722.GA808@in.ibm.com> <20070402140938.GF17710@sergelap.austin.ibm.com> <20070402142727.GF2456@in.ibm.com> <m1slbiejt0.fsf@ebiederm.dsl.xmission.com> <20070403153220.GA24946@sergelap.austin.ibm.com> <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com> <20070403164615.GJ2456@in.ibm.com> <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com> <20070403171155.GK2456@in.ibm.com> <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:10:35AM -0700, Paul Menage wrote:
> > Even if nsproxy objects are made larger a bit, the number of such object will
> 
> You're not making them "a bit" larger, you're adding N+M pointers
> where N is the number of container hierarchies and M is the number of
> subsystem slots.

Hmm no .. I currently have nsproxy having just M additional pointers, where 
M is the maximum number of resource controllers and a single dentry
pointer. As tasks get moved around in different hierarchies, new nsproxy's get 
created to point to proper objects in those hierarchies (which can be done with 
just M pointers in nsproxy). I have not considered the case of "search/reuse
nsproxy that has the combination you want" just to keep it simple, but
we should at some point in time do that.

-- 
Regards,
vatsa
