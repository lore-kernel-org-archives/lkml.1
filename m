Return-Path: <linux-kernel-owner+w=401wt.eu-S1751174AbXBMIQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbXBMIQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbXBMIQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:16:34 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50003 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbXBMIQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:16:33 -0500
Date: Tue, 13 Feb 2007 13:46:25 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, pj@sgi.com, ebiederm@xmission.com,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       serue@us.ibm.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070213081625.GA4252@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com> <20070212123309.GA7526@in.ibm.com> <6599ad830702121126o35fb0cb6x696a4a56079bce40@mail.gmail.com> <6599ad830702121146y41c8856cm4a85943aa950771f@mail.gmail.com> <20070213054857.GD22982@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213054857.GD22982@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 11:18:57AM +0530, Srivatsa Vaddagiri wrote:
> Which make me wonder why we need task_lock() at all ..I can understand
> the need for a lock like that if we are reading/updating multiple words
> in task_struct under the lock. In this case, it is used to read/write
> just one pointer, isnt it? I think it can be eliminated all-together
> with the use of RCU.

I see that cpuset.c uses task_lock to read/write multiple words
(cpuset_update_task_memory_state) ..So yes it is necessary in attach_task() ..


-- 
Regards,
vatsa
