Return-Path: <linux-kernel-owner+w=401wt.eu-S934011AbXDCQjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011AbXDCQjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934012AbXDCQjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:39:07 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58692 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934011AbXDCQjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:39:04 -0400
Date: Tue, 3 Apr 2007 22:16:15 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070403164615.GJ2456@in.ibm.com>
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
> the container_group object that I introduced in my latest patches,

So are you saying lets (re-)use tsk->nsproxy but also retain 'struct
container' to store general per-group state? If so, I think that would 
address my main concern of redundant/avoidable new pointers in
task_struct introduced in the container patches ..


-- 
Regards,
vatsa
