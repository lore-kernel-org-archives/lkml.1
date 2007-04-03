Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbXDCQIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbXDCQIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXDCQIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:08:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47257 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbXDCQIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:08:39 -0400
Date: Tue, 3 Apr 2007 21:46:04 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070403161604.GH2456@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070331024722.GA808@in.ibm.com> <20070402140938.GF17710@sergelap.austin.ibm.com> <20070402142727.GF2456@in.ibm.com> <m1slbiejt0.fsf@ebiederm.dsl.xmission.com> <20070403153220.GA24946@sergelap.austin.ibm.com> <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 08:45:37AM -0700, Paul Menage wrote:
> Whilst I've got no objection in general to using nsproxy rather than
> the container_group object that I introduced in my latest patches, I
> think that Vatsa's approach of losing the general container object is
> flawed, since it loses any kind of per-group generic state (e.g. "this
> container is being deleted")

I think I should post the updated version what I have soon. It handles
the "container/task group being deleted" case well, by setting
task/ns_proxy->count = 0. The only problem I need to resolve is
notify_on_release support (and also I haven't looked at the resource conters
patches yet).

> and last time I saw it, I think it would
> tend to lose processes so that they didn't show up in any directory in
> the container fs.

I think these are fixed in the latest version I have. Will send out to
you later this week (as soon as I drag myself off a higher prio task!).

-- 
Regards,
vatsa
