Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZDLJk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZDLJk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 05:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbZDLJkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 05:40:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:22917 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbZDLJks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 05:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=deEUDWUDGQ7PCCxsPLkBJ09Ji5VwdKHVD9eOfCaPlPZhpNwJLbwt3bfdv0TEVwqJkM
         5y/fPZFqGBo3DVcblJ7+D2Sck9i4XypF7N141dGEY7j2vcB5EN53xdmNAGCsKH0a4SNL
         gjncLlnVjC9wvuIEbLRsG5D2SwLUGVeIq73Go=
Date: Sun, 12 Apr 2009 13:40:44 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, tytso@mit.edu, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing: Document the event tracing system
Message-ID: <20090412094044.GA6942@lenovo>
References: <1239479479-2603-3-git-send-email-tytso@mit.edu> <tip-1542263998a2d143596972b2776c59c9247578a7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-1542263998a2d143596972b2776c59c9247578a7@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Theodore Ts'o - Sun, Apr 12, 2009 at 09:27:58AM +0000]
| Commit-ID:  1542263998a2d143596972b2776c59c9247578a7
| Gitweb:     http://git.kernel.org/tip/1542263998a2d143596972b2776c59c9247578a7
| Author:     Theodore Ts'o <tytso@mit.edu>
| AuthorDate: Sat, 11 Apr 2009 15:51:18 -0400
| Committer:  Ingo Molnar <mingo@elte.hu>
| CommitDate: Sun, 12 Apr 2009 11:23:48 +0200
| 
| tracing: Document the event tracing system
| 
| Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
| Cc: Theodore Ts'o <tytso@mit.edu>
| Cc: Steven Rostedt <rostedt@goodmis.org>
| LKML-Reference: <1239479479-2603-3-git-send-email-tytso@mit.edu>
| Signed-off-by: Ingo Molnar <mingo@elte.hu>
| 
| 
| ---
|  Documentation/trace/events.txt |  132 ++++++++++++++++++++++++++++++++++++++++
|  1 files changed, 132 insertions(+), 0 deletions(-)
| 
...
| +The events which are available for tracing can be found in the file
| +/sys/kernel/debug/tracing/available_events.
| +
| +To enable a particular event, such as 'sched_wakeup', simply echo it to
| +/sys/debug/tracing/set_event.  For example:
| +
| +	# echo sched_wakeup > /sys/kernel/debug/tracing/set_event
| +
| +To disable an event, echo the event name to the set_event file prefixed
| +with an exclamation point:
| +
| +	# echo '!sched_wakeup' >> /sys/kernel//debug/tracing/set_event
					    ^^^
Since it's just being added and easy to fix (later maybe via trivial tree),
I suppose here is quite a small misprint :)

| +
| +To disable events, echo an empty line to the set_event file:
| +
| +	# echo > /sys/kernel/debug/tracing/set_event
| +
...

        Cyrill
