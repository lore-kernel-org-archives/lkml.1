Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbYGNSJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbYGNSJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbYGNSIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:08:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbYGNSIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:08:51 -0400
Date: Mon, 14 Jul 2008 13:02:37 -0500
From: David Teigland <teigland@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH] ftrace: Documentation
Message-ID: <20080714180237.GB11644@redhat.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 12:46:01PM -0400, Steven Rostedt wrote:
> +The File System
> +---------------
> +
> +Ftrace uses the debugfs file system to hold the control files as well
> +as the files to display output.
> +
> +To mount the debugfs system:
> +
> +  # mkdir /debug
> +  # mount -t debugfs nodev /debug


I believe /sys/kernel/debug is the proper mount point.

Dave

