Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbXJIQC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbXJIQC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbXJIQCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:02:44 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:27966 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756047AbXJIQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:02:43 -0400
X-YMail-OSG: bBTUzA8VM1m_v8WOHOOQExq9pAIt1oxoCM6rewApWnmlepssK0zuwnbqt4amu4NxJU8mAwtYvg--
X-RocketYMMF: rancidfat
Date: Tue, 9 Oct 2007 09:02:42 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1191937926.24970.69.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <700885.76235.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Mon, 2007-10-08 at 10:31 -0700, Casey Schaufler wrote:
> > ...
> > I wouldn't expect the whole thing to be more than a couple week's
> > work for someone who really wanted to do it.
> 
> Note that Serge said "SELinux re-written on top of Smack", not "rewrite
> Smack to be more like SELinux".

Sorry, the subtlety of the difference seems insignificant to me.

> I don't believe the former is even
> possible, given that Smack is strictly less expressive and granular by
> design. Rewriting Smack to be more like SELinux should be possible,

As I outlined, it wouldn't be that hard to rewack SELinux from Smack.

> but seems like more work than emulating Smack on SELinux via policy,

Y'all keep saying that, but since noone has actually done that
SELinux policy, or anything like it, I maintain that it's not as
easy as you are inclined to claim. It is certainly not the "I'll
whip it up this weekend" sort of task that some have suggested.

> and to what end?

Well, there is that. I personally think that one implementation of
SELinux is plenty.

On the other hand, I think that if the concept of a single security
architecture has value the advocates of that position ought to be
looking at SELinux on/of Smack just as carefully as they look at
Smack on/of SELinux. If they are not, I suggest that the Single
Security Architecture argument is a sophistic device rather than
a legitimate issue of technology and should thus be ignored.


Casey Schaufler
casey@schaufler-ca.com
