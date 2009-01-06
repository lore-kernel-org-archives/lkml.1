Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbZAFQQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbZAFQQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZAFQQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:16:29 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:54132 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZAFQQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:16:29 -0500
Date: Tue, 6 Jan 2009 09:58:29 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add in_execve flag into task_struct.
Message-ID: <20090106155829.GA9773@us.ibm.com>
References: <200901060514.n065E462074929@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901060514.n065E462074929@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> Serge,
> 
> James is now reviewing TOMOYO Linux patch and he is caring about
> your comment below.
> 
> Serge E. Hallyn wrote:
> > I don't like the 'in_exec' bit in the task_struct, but adding LSM hooks
> > to let just TOMOYO mark whether you're in exec seems even uglier.
> 
> Let me (once again) ask your comment on 'in_exec' approach
> originally suggested by David Howells ( http://lkml.org/lkml/2008/10/2/127 ).

I still don't like it.  Now I gather the reason for this is that you
want to allow a less trusted domain to execute a file (in a new domain)
without giving it the right to read it?  I'd be interested in hearing
whether others think that's a worthy goal.

-serge
