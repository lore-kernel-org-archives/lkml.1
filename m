Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab0BCWtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:49:09 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39860 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab0BCWtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:49:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QBw0+Ei0rd2xR6v85PWHVHKLClncughtYqyF2uuXdpKcQCJkDHZ4ufEIADYbD7MEaA
         7KtvyynJhWbvjO6JnUaijA1S3qopczxbCb7i3HAqtnu6f3gIAnPt6s5w/pl4DXc7EEqw
         NsqNvizAGMoqDthK8imInEpQmNNZKRyfubx0Y=
Date: Wed, 3 Feb 2010 23:48:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@redhat.com>, David Miller <davem@davemloft.net>,
       heiko.carstens@de.ibm.com, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3] ftrace: unify arch_syscall_addr() implementations
Message-ID: <20100203224855.GH5068@nowhere>
References: <1264230643-29434-1-git-send-email-vapier@gentoo.org> <1264498803-17278-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264498803-17278-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 04:40:03AM -0500, Mike Frysinger wrote:
> Most implementations of arch_syscall_addr() are the same, so create a
> default version in common code and move the one piece that differs (the
> syscall table) to asm/syscall.h.  New arch ports don't have to waste
> time copying & pasting this simple function.
> 
> The s390/sparc versions need to be different, so document why.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Acked-by: David S. Miller <davem@davemloft.net>
> Acked-by: Paul Mundt <lethal@linux-sh.org>


Thanks!

I'm queuing it, unless Steve has already beaten me at it :)

