Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbXLFVMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbXLFVMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbXLFVMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:12:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:38378 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751750AbXLFVMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:12:22 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18Y0IBNI0AYrI4azrzvRHWpB6V/aV2VHtuHzozfFS
	T7/1V4KY+8Mgau
Date: Thu, 6 Dec 2007 22:12:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Markus <M4rkusXXL@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: programs vanish with 2.6.22+
In-Reply-To: <200712061927.35976.M4rkusXXL@web.de>
Message-ID: <Pine.LNX.4.64.0712062207320.25344@axis700.grange>
References: <200712061906.42070.M4rkusXXL@web.de> <200712061927.35976.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007, Markus wrote:

> Just forgot to mention:
> dmesg gives nothing (/var/log/messages)
> the global X log aswell
> 
> and in the users .xsession-errors I have:
> amarokapp: Fatal IO error: client killed
> kdesktop: Fatal IO error: client killed
> konqueror: Fatal IO error: client killed
> The application 'xchat' lost its connection to the display :0.0;
> 
> I dont know what that means, but at least its something ;)

Hm, no good idea, but some possible hints:

1. Ask Gentoo folks - if anyone has seen similar problems
2. RAM test - even if earlier kernels ran stable, the new one might stress 
your RAM differently
3. Are you sure nothing else has changed apart from the kernel?
4. You might try to recompile a vanilla 2.6.23+ kernel and enable as many 
kernel debugging options as you can...
5. Are you sure the installed kernel matches your CPU and your user-space 
64- / 32-bit combination? Don't know whether a wrongly configured kernel 
could cause such problems though

Good luck
Guennadi

> 
> Markus
> 
> > Hello!
> > 
> > Excuse my bad english, I am no native speaker. And please CC me, as I 
> am 
> > not subscribed!
> > 
> > I am running an amd64 system with a stable gentoo. Today I upgraded to 
> > the kernel 2.6.22 and noticed many programs to disappear.
> > I use a kde desktop (3.5.7) and when amarok or kmail crash, normaly 
> > a "kde-crash-manager" pops up (but that happend very rarely), but not 
> > with 2.6.22+. It happens often and without any messagebox.
> > kdesktop, xchat, kicker, konqueror crashed as well.
> > It happens more often under heavy load. But it can also happen when 
> > idle. Also I have the feeling that it happens more often on 2.6.23+ I 
> > might be wrong.
> > 
> > I tried 2.6.23 and the current 2.6.24-rc4, which all show this problem 
> > aswell!
> > What has changed in 2.6.21 -> 2.6.22 that could cause such things?
> > Or who can tell that?
> > Can I help? How? (I use linux for years and can code, but I never 
> > debugged anything as big as the kernel...)
> > 
> > 
> > Markus
> > 
> > PS: Sorry thats so late, but I normaly stay on the distros stable 
> kernel 
> > and only try vanilla when something is wrong ;)
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski
