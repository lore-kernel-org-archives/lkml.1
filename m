Return-Path: <linux-kernel-owner+w=401wt.eu-S1757762AbXGEGay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbXGEGay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 02:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbXGEGap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 02:30:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48152 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbXGEGao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 02:30:44 -0400
Date: Wed, 4 Jul 2007 23:30:08 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH -mm 0/3] configfs: Miscellaneous cleanups
Message-ID: <20070705063008.GF17650@tasint.org>
Mail-Followup-To: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	David Teigland <teigland@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mark.fasheh@oracle.com>
References: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 04:37:01PM +0530, Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [0/3] configfs: Miscellaneous cleanups
> 
> Simple cleanups for configfs (plus DLM and OCFS2, wherever applicable).
> This is diffed against 2.6.22-rc6-mm1.

	All three are pretty clean and useful.

> [1/3] configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h

	I thought I had this already.  If someone is using it (and
fs/dlm obviously is), we should provide it for the general case.

> [2/3] configfs+dlm+ocfs2: Convert subsystem semaphore to mutex

	I've just been lazy about this one.  Thank you.

> [3/3] configfs+dlm: Rename config_group_find_obj and state semantics clearly

	Makes sense as well.

	Any dissent from other subsystems?  If not, expect these to
show up in the ocfs2 tree soon-ish (I'm currently on vacation :-)

Joel

-- 

"Well-timed silence hath more eloquence than speech."  
         - Martin Fraquhar Tupper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
