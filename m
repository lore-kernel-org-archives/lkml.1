Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYKNDlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYKNDlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYKNDlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:41:35 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60480 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYKNDle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:41:34 -0500
Date: Thu, 13 Nov 2008 21:41:30 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v9][PATCH 12/13] Checkpoint multiple processes
Message-ID: <20081114034130.GA14171@us.ibm.com>
References: <1226335060-7061-1-git-send-email-orenl@cs.columbia.edu> <1226335060-7061-13-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226335060-7061-13-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> Checkpointing of multiple processes works by recording the tasks tree
> structure below a given task (usually this task is the container init).
> 
> For a given task, do a DFS scan of the tasks tree and collect them
> into an array (keeping a reference to each task). Using DFS simplifies
> the recreation of tasks either in user space or kernel space. For each
> task collected, test if it can be checkpointed, and save its pid, tgid,
> and ppid.
> 
> The actual work is divided into two passes: a first scan counts the
> tasks, then memory is allocated and a second scan fills the array.
> 
> The logic is suitable for creation of processes during restart either
> in userspace or by the kernel.
> 
> Currently we ignore threads and zombies, as well as session ids.
> 
> Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>

Looks good.

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge
