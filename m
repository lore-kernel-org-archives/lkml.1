Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbYBGQlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbYBGQlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbYBGQlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:41:39 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:39547 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbYBGQlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:41:39 -0500
X-Authority-Analysis: v=1.0 c=1 a=2HmMTTs1NPSFH2WIN6IA:9
 a=Pc6e1a24mgamMXwCi-8uZqxWGm8A:4 a=XF7b4UCPwd8A:10
Subject: Re: 2.6.24-git15 Keyboard Issue?
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.1.00.0802071629350.9204@apollo.tec.linutronix.de>
References: <1202302978.9058.13.camel@popeye>
	 <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
	 <1202305740.9058.22.camel@popeye>
	 <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
	 <1202318666.6406.13.camel@popeye>
	 <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
	 <1202381094.6179.0.camel@popeye>
	 <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>
	 <alpine.LFD.1.00.0802071324410.9204@apollo.tec.linutronix.de>
	 <1202396868.6087.8.camel@popeye>
	 <alpine.LFD.1.00.0802071629350.9204@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 10:45:04 -0600
Message-Id: <1202402704.6087.12.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas - 

I hope that, from at least my perspective, your question is rhetorical.
I am fully willing to publicly admit that I don't have a clue. About
much of anything. I will even admit that until prompted by Jiri
yesterday I had never even heard of the nohpet directive for the boot
line. 


I am willing to do whatever I can to help isolate and or resolve this
issue, but to do so I need one of you experts to firmly grab hold of
some portion of my anatomy and guide me in the right direction.

Chris



On Thu, 2008-02-07 at 17:13 +0100, Thomas Gleixner wrote:
> On Thu, 7 Feb 2008, Chris Holvenstot wrote:
> 
> > OK - I think that this is wat you are looking for.   If there is
> > anything else I can proivde or if I have mucked up this simple cut and
> > paste just let me know.
> > 
> > /proc/timer_list after a "standard" boot up:
> > Tick Device: mode:     1
> > Clock Event Device: pit
>  
> > /proc/timer_list after a boot with nohpet
> > Tick Device: mode:     1
> > Clock Event Device: pit
> 
> Both use PIT, so no hpet involved
> 
> > The dmesg output after a "standard" boot:
> 
> > [    0.000000] Kernel command line: root=UUID=4dc2e6b0-c980-418b-8ad0-98358e7ec47d ro quiet splash
> > [    0.368027] Time: acpi_pm clocksource has been installed.
> 
>  
> > The dmesg output after a boot with "nohpet"
> 
> > [    0.000000] Kernel command line: root=UUID=4dc2e6b0-c980-418b-8ad0-98358e7ec47d ro quiet splash nohpet
> > [    0.368027] Time: acpi_pm clocksource has been installed.
> 
> Both boots use acpi_pm clocksource and there is nowhere a sign of HPET
> in the logs except the "nohpet" on the command line.
> 
> /me is confused 
> 
> How does "nohpet" on the command line influence the behaviour, when
> there is no hpet available at all.
> 
> Thanks,
> 	tglx
> 
> 

