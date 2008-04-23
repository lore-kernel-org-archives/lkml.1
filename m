Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYDWPSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYDWPSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 11:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYDWPR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 11:17:59 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:36787 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbYDWPR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 11:17:58 -0400
Message-ID: <480F5321.9030008@fr.ibm.com>
Date: Wed, 23 Apr 2008 17:17:53 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Oren Laadan <orenl@cs.columbia.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFC PATCH 5/5] Add a Signal Control Group Subsystem
References: <20080423142517.062433911@us.ibm.com> <20080423142518.703428301@us.ibm.com>
In-Reply-To: <20080423142518.703428301@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Matt !

> Add a signal control group subsystem that allows us to send signals to all tasks
> in the control group by writing the desired signal(7) number to the kill file.
> 
> NOTE: We don't really need per-cgroup state, but control groups doesn't support
> stateless subsystems yet.
> 
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> ---
>  include/linux/cgroup_signal.h |   28 +++++++++
>  include/linux/cgroup_subsys.h |    6 +
>  init/Kconfig                  |    6 +
>  kernel/Makefile               |    1 
>  kernel/cgroup_signal.c        |  129 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 170 insertions(+)


I think there is a small race with new tasks entering the cgroup
while it's beeing killed, and a _fork ops would handle that. nop ? 

Thanks,

C. 
