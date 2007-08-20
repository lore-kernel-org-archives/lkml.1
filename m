Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbXHTO3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbXHTO3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 10:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760141AbXHTO3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 10:29:38 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:29471 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756312AbXHTO3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 10:29:37 -0400
X-YMail-OSG: 529UenkVM1lEQwTJQuQLMVnzgBITjWDLpKKYpNjuAM9XP2DEOiGfxqhgCH8mxwfLuuPItwZiFw--
X-RocketYMMF: rancidfat
Date: Mon, 20 Aug 2007 07:29:36 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Kyle Moffett <mrmacman_g4@mac.com>, casey@schaufler-ca.com
Cc: Pavel Machek <pavel@ucw.cz>, linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CB1BB3E1-68AB-4F7E-B8F8-466C4E471856@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <766922.14722.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> Finally moved back in and with internet.  Yay!
> 
> On Aug 17, 2007, at 00:56:44, Casey Schaufler wrote:
> > It would not surprise me particularly much if Kyle or someone like  
> > him could produce a perl script that could generate an SELinux  
> > policy that, when added to the reference policy on a system  
> > described by the reference policy, could do a fair imitation of the  
> > Smack scheme.
> 
> Umm, when did I ever say "emulate smack on top of the reference  
> policy"?  I state categorically that I can write an estimated 500  
> line perl script which will generate a standalone SELinux policy  
> based directly on a smack ruleset.

Even better. 

> It would require no additional  
> policy beyond what the script outputs, and the script would be only  
> roughly 500 lines so it can't contain all that much direct source-to- 
> output text.

Better still.

> I've started tinkering with that perl script, though I probably won't  
> get it finished till tomorrow or sunday.

Ok. I've been a developement manager, so I'll expect it Thursday.
(That's a Pointy Haired Manager joke, BTW)
 
> > One point that I would like to make clear however is that the  
> > requirement for a 400,000 line reference policy for a jumping off  
> > point is one of the reasons for Smack.
> 
> There is no "requirement" for a 400,000-line reference policy to  
> reproduce exactly the behavior of SMACK.  The SMACK architecture is  
> trivial

I prefer "simple" over "trivial", but yes, you have the nut of it.

> and therefore the SELinux policy is also simple.

Well, that's what the exercise is out to demonstrate. I admit to
being curious to see the proposed policy.

> >> and argue that SMACK is better, anyway, because of its  
> >> simplicity / speed / something.
> >
> > My understanding of the current SELinux philosophy is that policy  
> > should only be written by professionals, and that this was "always"  
> > the intention. I respect that, and for policy that requires the  
> > level of sophistication that SELinux does I would have a hard time  
> > arguing otherwise.
> 
> I can also state categorically that given the set of all admins,  
> users, and software developers, hardly a fraction of them are  
> qualified to write security policy at all.

I can understand your postion on the SELinux policy.

> Hell, most admins and  
> software developers can't get SUID binaries right,

Sadly true.

> and that's a  
> thousand times simpler than a MAC security policy.

Now you see, I don't agree with that. It's simpler than an SELinux
policy. It's not simpler than a Bell & LaPadula (once we were able
to get past the initial resistance to MAC and get someone a three
day training class they were able to do some cool things) and it's
certainly not simpler than Smack.

> Ergo the only  
> people who should be writing security policy for deployment are those  
> people who have studied and trained in the stuff.  Those people are  
> also known as "security professionals".

If only security professionals can use the system you have failed
to provide a general purpose facility. It may have value in limited
circumstances but it is not for everybody.

> > One of the things that limited the widespread adoption of MLS  
> > systems was that the policy, even one as simple as Bell & LaPadula,  
> > was considered to complex for most uses. I do not see that SELinux,  
> > or AppArmor for that matter, addresses this fundimental impediment  
> > to the use of mandatory access control. Yes, you can do just about  
> > anything with the right combination of classes, booleans, and other  
> > interesting facilities, but you can't do simple things directly.
> 
> Neither security nor your average distro nowadays is "simple" by any  
> stretch of the imagination.  Hell, my desktop system hits at least 2  
> million unique lines of code during boot, let alone logging in to  
> XFCE.  If you can show me a security system other than SELinux which  
> is sufficiently flexible to secure those 2 million lines of code  
> along with the other 50 million lines of code found in various pieces  
> of software on my Debian box then I'll go put on my dunce hat and sit  
> in the corner.

It is my position that the SELinux reference policy fails the
"small enough to analyze" clause of the TCB principle.
As a result SELinux does not help me feel secure. Restating
the complexity of the applications in the policy is arguably an
improvement, but I can't help but think the effort would be better
put into fixing the applications.

So long as your definition of "secure" allows for something other
than "runs SELinux", and so long as you are willing to accept the
conclusions of "security professionals", I can point to several
examples of systems that have been evaluated using other mechanisms.
There aren't other mechanisms upstream in Linux yet.


Casey Schaufler
casey@schaufler-ca.com
