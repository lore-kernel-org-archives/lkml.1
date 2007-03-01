Return-Path: <linux-kernel-owner+w=401wt.eu-S1752405AbXCANwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752405AbXCANwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbXCANwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:52:30 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:43445 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbXCANw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:52:29 -0500
Message-ID: <45E6DA9A.2030301@blueyonder.co.uk>
Date: Thu, 01 Mar 2007 13:52:26 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Avi Kivity <avi@argo.co.il>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E5DE32.2070902@argo.co.il>
In-Reply-To: <45E5DE32.2070902@argo.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> Sid Boyce wrote:
> > >>/ openSUSE 10.3 Alpha and KDE-3.5.6, xorg-x11-7.2. KDE is setup 
> not to/
> > >>/ require a password to unlock, but it asks for password. When the
> > screen/
> > >>/ unlocks, kwin is gone with no errors logged in /var/log/kdm or/
> > >>/ /var/log/messages. No problems with 2.6.20./
> > >>
> > >>/ Same problem on openSUSE 10.2 x86_64, KDE-3.5.5 and 2.6.21-rc2./
> > >>/ Regards/
> > >>/ Sid./
> >
> > > This is the linux kernel mailing list. Perhaps you should post your
> > problem to
> > > the opensuse mailing list.
> > >
> > > Regards
> > That's very much appreciated. The point is that all vanilla kernels up
> > to 2.6.20+ have not had the problems now seen on 2.6.20-rc1 and
> > 2.6.20-rc2 and like other problems reported, sic framebuffer, etc.,
> > there is a distinct likelihood that it's related to those kernels and
> > worth reporting here where it will also be seen by the openSUSE kernel
> > developers.
>
> Try running an strace on kwin and reporting the result.
>
>
> -- 
> Do not meddle in the internals of kernels, for they are subtle and 
> quick to panic.
>
Modified /opt/kde3/bin/startkde as below, but got no output, not even an 
empty file.
strace -s 256 -f kwin --lock -o /home/lancelot/KWIN.out &
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


