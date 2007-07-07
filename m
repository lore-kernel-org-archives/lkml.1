Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbXGGFdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbXGGFdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 01:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbXGGFdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 01:33:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:56245 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbXGGFdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 01:33:09 -0400
Date: Fri, 6 Jul 2007 22:32:36 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH -mm 0/3] configfs: Miscellaneous cleanups
Message-ID: <20070707053235.GA1011@tasint.org>
Mail-Followup-To: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	David Teigland <teigland@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mark.fasheh@oracle.com>
References: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in> <20070705063008.GF17650@tasint.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705063008.GF17650@tasint.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 11:30:08PM -0700, Joel Becker wrote:
> > [1/3] configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h
> 
> 	I thought I had this already.  If someone is using it (and
> fs/dlm obviously is), we should provide it for the general case.

	Ok, this is in my tree.

> > [2/3] configfs+dlm+ocfs2: Convert subsystem semaphore to mutex
> > [3/3] configfs+dlm: Rename config_group_find_obj and state semantics clearly

	These break against mainline.  I'm going to merge them against
mainline (shouldn't be hard), but I wonder if they are going to break
-mm, specifically conflicting against the DLM patches.  Andrew, do you
have a preference how we handle this?

Joel

-- 

"Always give your best, never get discouraged, never be petty; always
 remember, others may hate you.  Those who hate you don't win unless
 you hate them.  And then you destroy yourself."
	- Richard M. Nixon

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
