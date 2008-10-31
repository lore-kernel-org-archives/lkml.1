Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbYJaN7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbYJaN7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYJaN67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:58:59 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35712 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYJaN66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:58:58 -0400
Date: Fri, 31 Oct 2008 08:58:52 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v8][PATCH 11/12] External checkpoint of a task other than
	ourself
Message-ID: <20081031135852.GA11641@us.ibm.com>
References: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu> <1225374675-22850-12-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225374675-22850-12-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> Now we can do "external" checkpoint, i.e. act on another task.
> 
> sys_checkpoint() now looks up the target pid (in our namespace) and
> checkpoints that corresponding task. That task should be the root of
> a container.
> 
> sys_restart() remains the same, as the restart is always done in the
> context of the restarting task.
> 
> Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>

(Have looked this up and down, and it looks good, so while it's the
easiest piece of code to blame for the BUG() I'm getting, it doesn't
seem possible that it is)

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks, Oren.

-serge
