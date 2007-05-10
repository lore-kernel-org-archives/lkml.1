Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbXEJDJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbXEJDJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 23:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXEJDJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 23:09:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbXEJDJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 23:09:06 -0400
Date: Wed, 9 May 2007 20:08:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       charle97@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 8462] New: applications under wine freezes
Message-Id: <20070509200842.d2d93184.akpm@linux-foundation.org>
In-Reply-To: <200705100237.l4A2b5h8025394@fire-2.osdl.org>
References: <200705100237.l4A2b5h8025394@fire-2.osdl.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 19:37:05 -0700 bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8462

Let's do this via emailed reply-to-all, please.  bugzilla is more
appropriate for tracking of longer-term bugs.

>            Summary: applications under wine freezes
>     Kernel Version: 2.6.21-git
>             Status: NEW
>           Severity: normal
>              Owner: other_other@kernel-bugs.osdl.org
>          Submitter: charle97@yahoo.com
> 
> 
> Most recent commit where this bug did *NOT* occur:
>  commit a989705c4cf6e6c1a339c95f9daf658b4ba88ca8
>  Merge: 2d56d3c... d291825...
>  Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
>  Date:   Mon May 7 12:34:57 2007 -0700
> 
> Distribution: slackware 11.0
> 
> Problem Description:
> applications, namely starcraft and pokerstars, running under wine freezes
> shortly after starting the app.   
> 
> bisect produced the following commit:
>  commit 6192bd536f96c6a0d969081bc71ae24f9319bfdc
>  Author: Davide Libenzi <davidel@xmailserver.org>
>  Date:   Tue May 8 00:25:41 2007 -0700

Thanks for doing the bisection.

That's "epoll: optimizations and cleanups".

