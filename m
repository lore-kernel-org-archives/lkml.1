Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbXHUNQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbXHUNQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 09:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759873AbXHUNQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 09:16:21 -0400
Received: from smtpout.mac.com ([17.250.248.186]:60792 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759962AbXHUNQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 09:16:20 -0400
In-Reply-To: <19578.1187557961@turing-police.cc.vt.edu>
References: <638227.18984.qm@web36610.mail.mud.yahoo.com> <CB1BB3E1-68AB-4F7E-B8F8-466C4E471856@mac.com> <19578.1187557961@turing-police.cc.vt.edu>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <09E2BAC3-B26D-41BD-AE7B-51A59BC21CE4@mac.com>
Cc: casey@schaufler-ca.com, Pavel Machek <pavel@ucw.cz>,
       linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Date: Tue, 21 Aug 2007 09:16:07 -0400
To: Valdis.Kletnieks@vt.edu
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 19, 2007, at 17:12:41, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 18 Aug 2007 01:29:58 EDT, Kyle Moffett said:
>> If you can show me a security system other than SELinux which is  
>> sufficiently flexible to secure those 2 million lines of code  
>> along with the other 50 million lines of code found in various  
>> pieces of software on my Debian box then I'll go put on my dunce  
>> hat and sit in the corner.
>
> /me hands Kyle a dunce cap. :)
>
> Unfortunately, I have to agree that both AppArmor and Smack have at  
> least the potential of qualifying as "securing the 2M lines of code".
>
> The part that Kyle forgot was what most evals these days call the  
> "protection profile" - What's the threat model, who are you  
> defending against, and just how good a job does it have to do?   
> I'll posit that for a computer that is (a) not networked, (b)  
> doesn't process sensitive information, and (c) has reasonable  
> physical security, a security policy of "return(permitted);" for  
> everything may be quite sufficient.

Well, in this case the "box" I want to secure will eventually be  
running multi-user X on a multi-level-with-IPsec network.  For that  
kind of protection profile, there is presently no substitute for  
SELinux with some X11 patches.  AppArmor certainly doesn't meet the  
confidentiality requirements (no data labelling), and SMACK has no  
way of doing the very tight per-syscall security requirements we have  
to meet.  I didn't make this clear initially but that is the kind of  
system I'm talking about wanting to secure some 50 million lines of  
code on.


> (Of course, I also have boxes where "the SELinux reference policy  
> with all the MCS extensions plus all the LSPP work" is someplace  
> I'm trying to get to).

Well, for some of the systems we distribute, "all the MCS extensions  
plus all the LSPP work" is nowhere near enough security; we need full- 
fledged multi-level-security, role-based-access-control, and specific  
per-daemon MAC restrictions.

Cheers,
Kyle Moffett
