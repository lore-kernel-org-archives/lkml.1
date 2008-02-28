Return-Path: <linux-kernel-owner+w=401wt.eu-S932462AbYB1ViB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbYB1ViB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbYB1Vhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:37:53 -0500
Received: from smtp123.sbc.mail.re3.yahoo.com ([66.196.96.96]:45407 "HELO
	smtp123.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752116AbYB1Vhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:37:52 -0500
X-YMail-OSG: wA_RZH0VM1nkBtCcDfqVWRFzZRB_kT8l3xuvdWlKupuemcZxSO2.Q9DfyzxxVCCD1O7XUC.HgA--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 28 Feb 2008 15:35:07 -0600
From: serge@hallyn.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: serge@hallyn.com, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, Andrew Morgan <morgan@kernel.org>
Subject: Re: Fw: [PATCH 1/1] file capabilities: simplify signal check
Message-ID: <20080228213507.GD1232@vino.hallyn.com>
References: <20080223000237.518aace0.akpm@linux-foundation.org> <m17igu6e73.fsf@ebiederm.dsl.xmission.com> <20080227043306.GA9293@vino.hallyn.com> <m1tzjs4yn6.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tzjs4yn6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> serge@hallyn.com writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> Andrew Morton <akpm@linux-foundation.org> writes:
> >> 
> >> > um, is that code namespace-clean?
> >> 
> >> Choke, gag.
> >
> > Oh, sorry, I got lost in the set of patches in the message.  To be
> > clear, my little 4-patch uid-ns-signal patchset can simply be updated
> > to make the cap_task_kill() uid check into if (task_user_equiv(current, p)
> >
> > But Eric if you simply drop cap_task_kill() (don't make it return 0,
> > just drop the function and go back to not setting task_kill in the
> > capability_security_ops) I'll ack that.  Else I'll write the patch
> > thursday.  At this point the only thing that will be denied by
> > cap_task_kill() but not by check_kill_permission() is funky euid cases.
> > That's wrong.  (cc'ing amorgan in the event I'm forgetting something
> > useful the fn is doing)
> 
> Go ahead.   I'm fighting a cold and am fairly overloaded at the moment.
> 
> Eric

Thanks - patch sent a little while ago.  The description explains why
I believe cap_task_kill() became worthless (not just 'it's inconvenient' :)

-serge
