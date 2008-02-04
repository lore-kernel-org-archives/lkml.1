Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYBDV4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYBDV4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbYBDV4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:56:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39130 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755209AbYBDV4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:56:35 -0500
Date: Mon, 4 Feb 2008 13:56:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: cpw@sgi.com (Cliff Wickman)
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, clameter@sgi.com,
       rientjes@google.com, menage@google.com, cpw@sgi.com,
       Lee.Schermerhorn@hp.com
Subject: Re: [PATCH 2/4 v2] hotplug cpu move tasks in empty cpusets to
 parent various other fixes
Message-Id: <20080204135606.b6e1a065.akpm@linux-foundation.org>
In-Reply-To: <20080204174051.ACC3F1FE109@attica.americas.sgi.com>
References: <20080204174051.ACC3F1FE109@attica.americas.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Confused.

On Mon, 04 Feb 2008 11:40:51 -0600
cpw@sgi.com (Cliff Wickman) wrote:

> From: cpw@sgi.com (Cliff Wickman)
> To: linux-kernel@vger.kernel.org
> Cc: pj@sgi.com, clameter@sgi.com, rientjes@google.com, menage@google.com, cpw@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org
> Subject: [PATCH 2/4 v2] hotplug cpu move tasks in empty cpusets to parent various other fixes
> Date: Mon, 04 Feb 2008 11:40:51 -0600
> User-Agent: nail 11.25 7/29/05
> 
> 

The above implies that the patch was authored by Cliff.

> Various minor formatting and comment tweaks to Cliff Wickman's
> [PATCH_3_of_3]_cpusets__update_cpumask_revision.patch
> 
> I had had "iff", meaning "if and only if" in a comment.

And the "I" here implies that the patch was authored by Cliff.

> However, except for ancient mathematicians, the abbreviation
> "iff" was a tad too cryptic.  Cliff changed it to "if",
> presumably figuring that the "iff" was a typo.  However, it
> was the "only if" half of the conjunction that was most
> interesting.  Reword to emphasis the "only if" aspect.
> 
> The locking comment for remove_tasks_in_empty_cpuset() was wrong;
> it said callback_mutex had to be held on entry.  The opposite
> is true.
> 
> Several mentions of attach_task() in comments needed to be
> changed to cgroup_attach_task().
> 
> A comment about notify_on_release was no longer relevant,
> as the line of code it had commented, namely:
> 	set_bit(CS_RELEASED_RESOURCE, &parent->flags);
> is no longer present in that place in the cpuset.c code.
> 
> Similarly a comment about notify_on_release before the
> scan_for_empty_cpusets() routine was no longer relevant.
> 
> Removed extra parentheses and unnecessary return statement.
> 
> Renamed attach_task() to cpuset_attach() in various comments.
> 
> Removed comment about not needing memory migration, as it
> seems the migration is done anyway, via the cpuset_attach()
> callback from cgroup_attach_task().
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>
> Acked-by: Cliff Wickman <cpw@sgi.com>

But the signoffs imply that Paul was the author.

I'm going to assume it was Paul.

We indicate authorship by putting a "From: foo <bar@zot.com>" at the very
first line of the changelog.  If that is absent then we use the From: from email
headers.

Please remember to do this - it is more reliable than akpm forensics.
