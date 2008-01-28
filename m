Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYA1Upg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYA1Upg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYA1UpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:45:08 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39692 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbYA1UpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:45:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vinay Sridhar <vinay@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org, drepper@redhat.com, wli@holomorphy.com,
       sripathik@in.ibm.com
Subject: Re: [RFC] Per-thread getrusage
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>
	<20080127215242.b873c341.akpm@linux-foundation.org>
	<479D88C7.5030101@openvz.org>
	<20080128011010.d162d336.akpm@linux-foundation.org>
	<479DA289.7090403@openvz.org>
	<20080128014534.17630ddd.akpm@linux-foundation.org>
	<479DA711.3080301@openvz.org>
Date: Mon, 28 Jan 2008 13:43:02 -0700
In-Reply-To: <479DA711.3080301@openvz.org> (Pavel Emelyanov's message of "Mon,
	28 Jan 2008 12:57:37 +0300")
Message-ID: <m1ve5dheax.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@openvz.org> writes:
>> ...
>> +asmlinkage long sys_thread_getrusage(int tid, struct rusage __user *ru)
>> +{
>> +	struct task_struct *tsk;
>> +	tsk = find_task_by_pid(tid);
>> +	return getrusage(tsk, RUSAGE_THREAD, ru);
>> +}
>
> Well, the find_task_by_pid() is really wrong here.

And find_task_by_pid should probably just be removed.

No need to provide function with the gun firmly pointed at our feet....

Eric
