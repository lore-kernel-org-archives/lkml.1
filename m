Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbXHRFa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbXHRFa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 01:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXHRFaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 01:30:14 -0400
Received: from smtpout.mac.com ([17.250.248.186]:59878 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbXHRFaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 01:30:12 -0400
In-Reply-To: <638227.18984.qm@web36610.mail.mud.yahoo.com>
References: <638227.18984.qm@web36610.mail.mud.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CB1BB3E1-68AB-4F7E-B8F8-466C4E471856@mac.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Date: Sat, 18 Aug 2007 01:29:58 -0400
To: casey@schaufler-ca.com
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Finally moved back in and with internet.  Yay!

On Aug 17, 2007, at 00:56:44, Casey Schaufler wrote:
> It would not surprise me particularly much if Kyle or someone like  
> him could produce a perl script that could generate an SELinux  
> policy that, when added to the reference policy on a system  
> described by the reference policy, could do a fair imitation of the  
> Smack scheme.

Umm, when did I ever say "emulate smack on top of the reference  
policy"?  I state categorically that I can write an estimated 500  
line perl script which will generate a standalone SELinux policy  
based directly on a smack ruleset.  It would require no additional  
policy beyond what the script outputs, and the script would be only  
roughly 500 lines so it can't contain all that much direct source-to- 
output text.

I've started tinkering with that perl script, though I probably won't  
get it finished till tomorrow or sunday.


> One point that I would like to make clear however is that the  
> requirement for a 400,000 line reference policy for a jumping off  
> point is one of the reasons for Smack.

There is no "requirement" for a 400,000-line reference policy to  
reproduce exactly the behavior of SMACK.  The SMACK architecture is  
trivial and therefore the SELinux policy is also simple.


>> and argue that SMACK is better, anyway, because of its  
>> simplicity / speed / something.
>
> My understanding of the current SELinux philosophy is that policy  
> should only be written by professionals, and that this was "always"  
> the intention. I respect that, and for policy that requires the  
> level of sophistication that SELinux does I would have a hard time  
> arguing otherwise.

I can also state categorically that given the set of all admins,  
users, and software developers, hardly a fraction of them are  
qualified to write security policy at all.  Hell, most admins and  
software developers can't get SUID binaries right, and that's a  
thousand times simpler than a MAC security policy.  Ergo the only  
people who should be writing security policy for deployment are those  
people who have studied and trained in the stuff.  Those people are  
also known as "security professionals".


> One of the things that limited the widespread adoption of MLS  
> systems was that the policy, even one as simple as Bell & LaPadula,  
> was considered to complex for most uses. I do not see that SELinux,  
> or AppArmor for that matter, addresses this fundimental impediment  
> to the use of mandatory access control. Yes, you can do just about  
> anything with the right combination of classes, booleans, and other  
> interesting facilities, but you can't do simple things directly.

Neither security nor your average distro nowadays is "simple" by any  
stretch of the imagination.  Hell, my desktop system hits at least 2  
million unique lines of code during boot, let alone logging in to  
XFCE.  If you can show me a security system other than SELinux which  
is sufficiently flexible to secure those 2 million lines of code  
along with the other 50 million lines of code found in various pieces  
of software on my Debian box then I'll go put on my dunce hat and sit  
in the corner.


Cheers,
Kyle Moffett



