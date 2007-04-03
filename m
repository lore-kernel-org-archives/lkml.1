Return-Path: <linux-kernel-owner+w=401wt.eu-S965550AbXDCRGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550AbXDCRGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXDCRGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:06:07 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36840 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965550AbXDCRGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:06:05 -0400
Date: Tue, 3 Apr 2007 22:41:55 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, mbligh@google.com,
       winget@google.com, containers@lists.osdl.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070403171155.GK2456@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070331024722.GA808@in.ibm.com> <20070402140938.GF17710@sergelap.austin.ibm.com> <20070402142727.GF2456@in.ibm.com> <m1slbiejt0.fsf@ebiederm.dsl.xmission.com> <20070403153220.GA24946@sergelap.austin.ibm.com> <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com> <20070403164615.GJ2456@in.ibm.com> <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 09:52:35AM -0700, Paul Menage wrote:
> I'm not saying "let's use nsproxy" - I'm not yet convinced that the
> lifetime/mutation/correlation rate of a pointer in an nsproxy is
> likely to be the same as for a container subsystem; if not, then
> reusing nsproxy could actually increase space overheads (since you'd
> end up with more, larger nsproxy objects, compared to smaller numbers
> of smaller nsproxy objects and smaller numbers of smaller
> container_group objects), even though it saved (just) one pointer per
> task_struct.

Even if nsproxy objects are made larger a bit, the number of such object will
be -much- lesser compared to number of task_structs I would think, so
the win/lose in space savings would need to take that into account.


-- 
Regards,
vatsa
