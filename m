Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYHMEJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYHMEJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 00:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbYHMEJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 00:09:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbYHMEJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 00:09:23 -0400
Date: Tue, 12 Aug 2008 21:08:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Kashyap <kashyapv@us.ibm.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, containers@lists.linux-foundation.org,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org, menage@google.com,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH 0/5] Container Freezer v6: Reuse Suspend
 Freezer
Message-Id: <20080812210859.ff2fa2f4.akpm@linux-foundation.org>
In-Reply-To: <Pine.WNT.4.64.0808121927320.5336@IBM-8DE7FFDE2AB>
References: <20080811235323.872291138@us.ibm.com>
	<20080812154429.c5377bd0.akpm@linux-foundation.org>
	<Pine.WNT.4.64.0808121927320.5336@IBM-8DE7FFDE2AB>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 20:47:10 -0700 (Pacific Daylight Time) Vivek Kashyap <kashyapv@us.ibm.com> wrote:

> On Tue, 12 Aug 2008, Andrew Morton wrote:
> 
> > On Mon, 11 Aug 2008 16:53:23 -0700
> > Matt Helsley <matthltc@us.ibm.com> wrote:
> >
> >> This patch series introduces a cgroup subsystem that utilizes the swsusp
> >> freezer to freeze a group of tasks. It's immediately useful for batch job
> >> management scripts. It should also be useful in the future for implementing
> >> container checkpoint/restart.
> >
> > I don't think that this provides anything like sufficient detail to justify
> > merging a whole bunch of stuff into Linux.
> >
> > What does "It's immediately useful for batch job management scripts."
> > mean?  How is it useful?  Examples?  Why would an operator want this
> > feature, and how would it be used?  _much_ more information is needed!
> 
> A batch-manager/job scheduler (such as loadleveler)

what's that?

> must at times stop all 
> tasks associated with a workload being run in a container.

why?

I'm being deliberately obtuse here, but I'm afraid you guys haven't
come anywhere into the vague nearby neighbourhood of adequately describing
this feature.

Please provide proper and full reasons for merging this code into
Linux.  If they exist.  This shouldn't be too hard.

Please put yourself in my position:

me: [patch] <this stuff>
Linus: why are you sending me this?
me: I have not the faintest idea

trust me - many others will be in my position too.

> The workload may 
> constitute of multiple tasks - some of which are in different sessions. 
> A signal (STOP/CONT) to the Containers 'init' wont be transmitted to all 
> the tasks in the Container. The 'freezer' mechanism allows this control
> to be implemented in a clean way.

So why not implement a send-signal-to-all-tasks-in-a-container
controller?

