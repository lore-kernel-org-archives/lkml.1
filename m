Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYHMDr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYHMDr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 23:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYHMDrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 23:47:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53500 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbYHMDrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 23:47:19 -0400
Date: Tue, 12 Aug 2008 20:47:10 -0700 (Pacific Daylight Time)
From: Vivek Kashyap <kashyapv@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Matt Helsley <matthltc@us.ibm.com>, containers@lists.linux-foundation.org,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org, menage@google.com,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH 0/5] Container Freezer v6: Reuse Suspend
 Freezer
In-Reply-To: <20080812154429.c5377bd0.akpm@linux-foundation.org>
Message-ID: <Pine.WNT.4.64.0808121927320.5336@IBM-8DE7FFDE2AB>
References: <20080811235323.872291138@us.ibm.com>
 <20080812154429.c5377bd0.akpm@linux-foundation.org>
X-X-Sender: kashyapv@imap.linux.ibm.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008, Andrew Morton wrote:

> On Mon, 11 Aug 2008 16:53:23 -0700
> Matt Helsley <matthltc@us.ibm.com> wrote:
>
>> This patch series introduces a cgroup subsystem that utilizes the swsusp
>> freezer to freeze a group of tasks. It's immediately useful for batch job
>> management scripts. It should also be useful in the future for implementing
>> container checkpoint/restart.
>
> I don't think that this provides anything like sufficient detail to justify
> merging a whole bunch of stuff into Linux.
>
> What does "It's immediately useful for batch job management scripts."
> mean?  How is it useful?  Examples?  Why would an operator want this
> feature, and how would it be used?  _much_ more information is needed!

A batch-manager/job scheduler (such as loadleveler) must at times stop all 
tasks associated with a workload being run in a container. The workload may 
constitute of multiple tasks - some of which are in different sessions. 
A signal (STOP/CONT) to the Containers 'init' wont be transmitted to all 
the tasks in the Container. The 'freezer' mechanism allows this control
to be implemented in a clean way.

Vivek
>
> Once we've actually found out what this work is useful for, we can move
> onto identification of and discussion of alternatives.  One would be "why not
> use plain old SIGSTOP?"  Another alternative is, of course "that's not useful
> enough to justify merging the code".  But we don't know yet, coz you didn't
> tell us.
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
>

__

Vivek Kashyap
Linux Technology Center, IBM
