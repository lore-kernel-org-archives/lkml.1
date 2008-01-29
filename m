Return-Path: <linux-kernel-owner+w=401wt.eu-S1756447AbYA2IbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbYA2IbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 03:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYA2Iaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 03:30:55 -0500
Received: from sacred.ru ([62.205.161.221]:41030 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbYA2Iaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 03:30:55 -0500
Message-ID: <479EE401.2020309@openvz.org>
Date: Tue, 29 Jan 2008 11:29:53 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Vinay Sridhar <vinay@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org, drepper@redhat.com, wli@holomorphy.com,
       sripathik@in.ibm.com
Subject: Re: [RFC] Per-thread getrusage
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>	<20080127215242.b873c341.akpm@linux-foundation.org>	<479D88C7.5030101@openvz.org>	<20080128011010.d162d336.akpm@linux-foundation.org>	<479DA289.7090403@openvz.org>	<20080128014534.17630ddd.akpm@linux-foundation.org>	<479DA711.3080301@openvz.org> <m1ve5dheax.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ve5dheax.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 29 Jan 2008 11:29:38 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Pavel Emelyanov <xemul@openvz.org> writes:
>>> ...
>>> +asmlinkage long sys_thread_getrusage(int tid, struct rusage __user *ru)
>>> +{
>>> +	struct task_struct *tsk;
>>> +	tsk = find_task_by_pid(tid);
>>> +	return getrusage(tsk, RUSAGE_THREAD, ru);
>>> +}
>> Well, the find_task_by_pid() is really wrong here.
> 
> And find_task_by_pid should probably just be removed.
> 
> No need to provide function with the gun firmly pointed at our feet....

We are working to uncock it. If you feel you know how to do it
faster, it would be just terrific to review your patches.

> Eric
> 

