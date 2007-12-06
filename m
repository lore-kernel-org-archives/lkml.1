Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbXLFWVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbXLFWVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbXLFWVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:21:25 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:46957 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbXLFWVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:21:24 -0500
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: programs vanish with 2.6.22+
Date: Thu, 6 Dec 2007 23:21:00 +0100
User-Agent: KMail/1.9.7
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <200712061906.42070.M4rkusXXL@web.de> <200712061927.35976.M4rkusXXL@web.de> <Pine.LNX.4.64.0712062207320.25344@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0712062207320.25344@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712062321.01314.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1+g1RZYR5mT2XnyeU2p8SpAApHXhdbFwntXdzP2
	JxtKYKAFQ8Qq/tAAj0W6ezOCcZTFEobZO/3syG5yE8EBAlTRV3
	aurbFrrUQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 6. Dezember 2007 schrieb Guennadi Liakhovetski:
> On Thu, 6 Dec 2007, Markus wrote:
> 
> > Just forgot to mention:
> > dmesg gives nothing (/var/log/messages)
> > the global X log aswell
> > 
> > and in the users .xsession-errors I have:
> > amarokapp: Fatal IO error: client killed
> > kdesktop: Fatal IO error: client killed
> > konqueror: Fatal IO error: client killed
> > The application 'xchat' lost its connection to the display :0.0;
> > 
> > I dont know what that means, but at least its something ;)
> 
> Hm, no good idea, but some possible hints:
> 
> 1. Ask Gentoo folks - if anyone has seen similar problems
Noone gave a positiv answer so far.

> 2. RAM test - even if earlier kernels ran stable, the new one might 
stress 
> your RAM differently
Will do that overnight.

> 3. Are you sure nothing else has changed apart from the kernel?
Yes, I have some kernels installed and booted into them without changing 
anything else.

> 4. You might try to recompile a vanilla 2.6.23+ kernel and enable as 
many 
> kernel debugging options as you can...
I try that next.

> 5. Are you sure the installed kernel matches your CPU and your 
user-space 
> 64- / 32-bit combination? Don't know whether a wrongly configured 
kernel 
> could cause such problems though
Everything is "safe". Its a native 64-bit system with "safe" flags.

> 
> Good luck
> Guennadi
> 

I will write when I did a ram-test and am running a 24-rc4 with 
full-debug.
Will also try things from the gentoo-users...


Is there any userspace software that is needed with newer kernels?


Markus


> > 
> > Markus
> > 
> > > Hello!
> > > 
> > > Excuse my bad english, I am no native speaker. And please CC me, 
as I 
> > am 
> > > not subscribed!
> > > 
> > > I am running an amd64 system with a stable gentoo. Today I 
upgraded to 
> > > the kernel 2.6.22 and noticed many programs to disappear.
> > > I use a kde desktop (3.5.7) and when amarok or kmail crash, 
normaly 
> > > a "kde-crash-manager" pops up (but that happend very rarely), but 
not 
> > > with 2.6.22+. It happens often and without any messagebox.
> > > kdesktop, xchat, kicker, konqueror crashed as well.
> > > It happens more often under heavy load. But it can also happen 
when 
> > > idle. Also I have the feeling that it happens more often on 
2.6.23+ I 
> > > might be wrong.
> > > 
> > > I tried 2.6.23 and the current 2.6.24-rc4, which all show this 
problem 
> > > aswell!
> > > What has changed in 2.6.21 -> 2.6.22 that could cause such things?
> > > Or who can tell that?
> > > Can I help? How? (I use linux for years and can code, but I never 
> > > debugged anything as big as the kernel...)
> > > 
> > > 
> > > Markus
> > > 
> > > PS: Sorry thats so late, but I normaly stay on the distros stable 
> > kernel 
> > > and only try vanilla when something is wrong ;)
> > > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe 
linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> ---
> Guennadi Liakhovetski
> 


