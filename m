Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYAGMKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYAGMKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYAGMKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:10:12 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55291 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbYAGMKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:10:10 -0500
Date: Mon, 7 Jan 2008 17:53:30 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/11] another rt group sched update
Message-ID: <20080107122330.GB25945@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080106161128.152634000@chello.nl> <1199703080.7143.24.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199703080.7143.24.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 11:51:20AM +0100, Peter Zijlstra wrote:
>  - figure out what to do for UID based group scheduling, the current
>    implementation leaves it impossible for !root users to execute
>    real time tasks by setting rt_runtime_us to 0, and it has no way
>    to change it.
> 
>    Srivatsa, what happened to the per uid weight patches?, Perhaps we
>    can extend that interface to allow changing this.

Hi Peter,
	The sysfs interface for tweaking each user's share should be in
mainline already (sysfs_create_file() in user_kobject_create()). This
could be extended for your purpose, hopefully in a straightforward
manner (you never know that with sysfs :(

-- 
Regards,
vatsa
