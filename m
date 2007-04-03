Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbXDCQDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbXDCQDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbXDCQDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:03:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60248 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbXDCQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:03:38 -0400
Date: Tue, 3 Apr 2007 21:40:58 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, menage@google.com,
       akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070403161058.GG2456@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070331024722.GA808@in.ibm.com> <20070402140938.GF17710@sergelap.austin.ibm.com> <20070402142727.GF2456@in.ibm.com> <m1slbiejt0.fsf@ebiederm.dsl.xmission.com> <20070403153220.GA24946@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403153220.GA24946@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 10:32:20AM -0500, Serge E. Hallyn wrote:
> But frankly I don't know where we stand right now wrt the containers
> patches.  Do most people want to go with Vatsa's latest version moving
> containers into nsproxy?  

> Has any other development been going on?

I have another update to the rcfs patches more or less ready to go. I
hope to post them out this week.

Note that from user or controller perspective, there should be very
little difference between the two patches. rcfs is, I would say, same as
container patches to the extent of 70-80%. The rest of the difference is
mainly avoiding a new pointer in task_struct and new structures to
represent a task_group.

-- 
Regards,
vatsa
