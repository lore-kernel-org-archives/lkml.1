Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbXGEJI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbXGEJI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbXGEJIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:08:52 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:47555 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036AbXGEJIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:08:51 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Thu, 5 Jul 2007 15:00:20 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Joel Becker <Joel.Becker@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH -mm 0/3] configfs: Miscellaneous cleanups
In-Reply-To: <20070705063008.GF17650@tasint.org>
Message-ID: <Pine.LNX.4.64.0707051451560.15925@cselinux1.cse.iitk.ac.in>
References: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070705063008.GF17650@tasint.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

On Wed, 4 Jul 2007, Joel Becker wrote:
> On Wed, Jul 04, 2007 at 04:37:01PM +0530, Satyam Sharma wrote:
> > From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> > 
> > [0/3] configfs: Miscellaneous cleanups
> > 
> > Simple cleanups for configfs (plus DLM and OCFS2, wherever applicable).
> > This is diffed against 2.6.22-rc6-mm1.
> 
> 	All three are pretty clean and useful.
> 
> > [1/3] configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h
> 
> 	I thought I had this already.  If someone is using it (and
> fs/dlm obviously is), we should provide it for the general case.
> 
> > [2/3] configfs+dlm+ocfs2: Convert subsystem semaphore to mutex
> 
> 	I've just been lazy about this one.  Thank you.
> 
> > [3/3] configfs+dlm: Rename config_group_find_obj and state semantics clearly
> 
> 	Makes sense as well.
> 
> 	Any dissent from other subsystems?  If not, expect these to
> show up in the ocfs2 tree soon-ish (I'm currently on vacation :-)

Steven Whitehouse liked these too, and has given them his:

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

as well.

It was a wrong-email-id mistake by me in the initial post, and then
I made another mistake by doing the resend to only David and Steven
without copying in LKML and others (I thought I was doing something
good by not spamming the list / others). Sorry about the whole
episode -- I guess I'll live and learn :-)

Thanks,
Satyam
