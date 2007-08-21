Return-Path: <linux-kernel-owner+w=401wt.eu-S1762013AbXHUPvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762013AbXHUPvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759522AbXHUPux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:50:53 -0400
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:31058 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759501AbXHUPuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:50:52 -0400
X-YMail-OSG: aHWGbHEVM1kO50wso8K2.xvSQAOzyTx8fDXeEk9Lref3qURM8qz6r3zvblR9kr3qzPTgvM9oTg--
X-RocketYMMF: rancidfat
Date: Tue, 21 Aug 2007 08:50:48 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Kyle Moffett <mrmacman_g4@mac.com>, Valdis.Kletnieks@vt.edu
Cc: casey@schaufler-ca.com, Pavel Machek <pavel@ucw.cz>,
       linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <09E2BAC3-B26D-41BD-AE7B-51A59BC21CE4@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <583405.53562.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Aug 19, 2007, at 17:12:41, Valdis.Kletnieks@vt.edu wrote:
> > On Sat, 18 Aug 2007 01:29:58 EDT, Kyle Moffett said:
> >> If you can show me a security system other than SELinux which is  
> >> sufficiently flexible to secure those 2 million lines of code  
> >> along with the other 50 million lines of code found in various  
> >> pieces of software on my Debian box then I'll go put on my dunce  
> >> hat and sit in the corner.
> >
> > /me hands Kyle a dunce cap. :)
> >
> > Unfortunately, I have to agree that both AppArmor and Smack have at  
> > least the potential of qualifying as "securing the 2M lines of code".
> >
> > The part that Kyle forgot was what most evals these days call the  
> > "protection profile" - What's the threat model, who are you  
> > defending against, and just how good a job does it have to do?   
> > I'll posit that for a computer that is (a) not networked, (b)  
> > doesn't process sensitive information, and (c) has reasonable  
> > physical security, a security policy of "return(permitted);" for  
> > everything may be quite sufficient.
> 
> Well, in this case the "box" I want to secure will eventually be  
> running multi-user X on a multi-level-with-IPsec network.  For that  
> kind of protection profile, there is presently no substitute for  
> SELinux with some X11 patches.  AppArmor certainly doesn't meet the  
> confidentiality requirements (no data labelling), and SMACK has no  
> way of doing the very tight per-syscall security requirements we have  
> to meet.

And what requirements would those be? Seriously, I've done
Common Criteria and TCSEC evaluations on systems with less
flexibility and granularity than Smack that included X, NFSv3,
NIS, clusters, and all sorts of spiffy stuff. I mean, if the
requirement is anything short of "runs SELinux" I have good
reason to believe that a Smack based system is up to it.

> I didn't make this clear initially but that is the kind of  
> system I'm talking about wanting to secure some 50 million lines of  
> code on.

Cool. SELinux provides one approach to dealing with that, and the
huge multiuser general purpose machine chuck full of legacy software
hits the SELinux sweet spot. 

> > (Of course, I also have boxes where "the SELinux reference policy  
> > with all the MCS extensions plus all the LSPP work" is someplace  
> > I'm trying to get to).
> 
> Well, for some of the systems we distribute, "all the MCS extensions  
> plus all the LSPP work" is nowhere near enough security; we need full- 
> fledged multi-level-security, role-based-access-control, and specific  
> per-daemon MAC restrictions.

Sounds like more of what SELinux is good for.


Casey Schaufler
casey@schaufler-ca.com
