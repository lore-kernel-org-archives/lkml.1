Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbXKDQhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbXKDQhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 11:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXKDQhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 11:37:37 -0500
Received: from web36603.mail.mud.yahoo.com ([209.191.85.20]:33066 "HELO
	web36603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752854AbXKDQhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 11:37:36 -0500
X-YMail-OSG: j.fqVfAVM1ntP5gPuSImWZMbdqqn4YFufmrWTtZuvVOsvb1h6qGl4fndz.sl.VGsqV6111cY.w--
X-RocketYMMF: rancidfat
Date: Sun, 4 Nov 2007 08:37:35 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
To: "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>
Cc: Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1865922a0711040523k2f3dac51k8db872169fd518e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <467385.22908.qm@web36603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> On 11/4/07, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > > > Still to come:
> > > >
> > > >   - Final cleanup of smack_load_write and smack_cipso_write.
> > >
> > > Hi All,
> > >
> > > After agreeing with Casey on the "load" input grammar yesterday, here's
> > > the final grammar and its parser (which needs more testing):
> > >
> > > A Smack Rule in an "egrep" format is:
> > >
> > > "^[:space:]*Subject[:space:]+Object[:space:]+[rwxaRWXA-]+[:space:]*\n"
> > >
> > > where Subject/Object strings are in the form:
> > >
> > > "^[^/[:space:][:cntrl:]]{1,SMK_MAXLEN}$"
> >
> > Can we avoid string parsers in the kernel?

Woof. We've devolved into Al saying it must be done this way,
and Pavel saying it can't be done this way.

That's OK. Maybe it's time that I stepped back and came up
with a twisted mechanism for achieving my ends, as the obvious
mechanism appears as if it will always call down disapproval.
 
> I've suggested that at first, but (hoping not to misquote Al) Al viro
> said that the parsing is simple enough and no need exists for a
> user-space utility.
> 
> >
> > > +static inline int isblank(char c)
> > > +{
> > > +     return (c == ' ' || c == '\t');
> > > +}
> >
> > This sounds like enough for 'NAK'.
> >
> 
> Would you please show the reason for the NAK so I can modify the code ?

yeah, my head needs scratching after that one.

> 
> Thank you,
> 
> >                                                 Pavel,
> >                 who still thinks smack rules should be parsed
> >                 in userspace and compiled into selinux rules...

Casey, who still thinks Pavel doesn't get it.


Casey Schaufler
casey@schaufler-ca.com
