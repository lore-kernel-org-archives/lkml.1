Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbXHGHdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbXHGHdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXHGHda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:33:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754032AbXHGHd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:33:29 -0400
Date: Tue, 7 Aug 2007 00:32:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: sukadev@us.ibm.com
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC, PATCH] handle the multi-threaded init's exit() properly
Message-Id: <20070807003228.60d047b4.akpm@linux-foundation.org>
In-Reply-To: <20070807063431.GB23036@us.ibm.com>
References: <20070802212009.GA516@tv-sign.ru>
	<20070806131345.3322c99e.akpm@linux-foundation.org>
	<20070806203326.GA188@tv-sign.ru>
	<20070806221824.22a78312.akpm@linux-foundation.org>
	<20070807063431.GB23036@us.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007 23:34:31 -0700 sukadev@us.ibm.com wrote:

> | The downside of this approach is that
> | handle-the-multi-threaded-inits-exit-properly.patch looks more 2.6.24-ready
> | than all the container stuff (based just on overall impact and
> | speculativeness)
> 
> Well, if it will help, we can drop these two patches from -mm, take Oleg's
> patch and I can then resend these along with other pid ns patches. 
> 
> 	pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch.
> 	pid-namespaces-rename-child_reaper-function.patch

I'm reasonably sure that what I ended up with is OK.  I'll send those two
out again for double-checking, please.
