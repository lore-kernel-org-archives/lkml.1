Return-Path: <linux-kernel-owner+w=401wt.eu-S1763476AbYB1U1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763476AbYB1U1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbYB1U0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:26:49 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53817 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbYB1U0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:26:48 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: serge@hallyn.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, Andrew Morgan <morgan@kernel.org>
Subject: Re: Fw: [PATCH 1/1] file capabilities: simplify signal check
References: <20080223000237.518aace0.akpm@linux-foundation.org>
	<m17igu6e73.fsf@ebiederm.dsl.xmission.com>
	<20080227043306.GA9293@vino.hallyn.com>
Date: Thu, 28 Feb 2008 13:25:01 -0700
In-Reply-To: <20080227043306.GA9293@vino.hallyn.com> (serge@hallyn.com's
	message of "Tue, 26 Feb 2008 22:33:06 -0600")
Message-ID: <m1tzjs4yn6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serge@hallyn.com writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>> > um, is that code namespace-clean?
>> 
>> Choke, gag.
>
> Oh, sorry, I got lost in the set of patches in the message.  To be
> clear, my little 4-patch uid-ns-signal patchset can simply be updated
> to make the cap_task_kill() uid check into if (task_user_equiv(current, p)
>
> But Eric if you simply drop cap_task_kill() (don't make it return 0,
> just drop the function and go back to not setting task_kill in the
> capability_security_ops) I'll ack that.  Else I'll write the patch
> thursday.  At this point the only thing that will be denied by
> cap_task_kill() but not by check_kill_permission() is funky euid cases.
> That's wrong.  (cc'ing amorgan in the event I'm forgetting something
> useful the fn is doing)

Go ahead.   I'm fighting a cold and am fairly overloaded at the moment.

Eric
