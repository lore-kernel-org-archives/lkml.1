Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbYBGQOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbYBGQOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYBGQOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:14:11 -0500
Received: from www.tglx.de ([62.245.132.106]:56341 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbYBGQOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:14:10 -0500
Date: Thu, 7 Feb 2008 17:13:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Holvenstot <cholvenstot@comcast.net>
cc: Jiri Kosina <jkosina@suse.cz>, Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git15 Keyboard Issue?
In-Reply-To: <1202396868.6087.8.camel@popeye>
Message-ID: <alpine.LFD.1.00.0802071629350.9204@apollo.tec.linutronix.de>
References: <1202302978.9058.13.camel@popeye>  <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>  <1202305740.9058.22.camel@popeye>  <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>  <1202318666.6406.13.camel@popeye>  <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
  <1202381094.6179.0.camel@popeye>  <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>  <alpine.LFD.1.00.0802071324410.9204@apollo.tec.linutronix.de> <1202396868.6087.8.camel@popeye>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Chris Holvenstot wrote:

> OK - I think that this is wat you are looking for.   If there is
> anything else I can proivde or if I have mucked up this simple cut and
> paste just let me know.
> 
> /proc/timer_list after a "standard" boot up:
> Tick Device: mode:     1
> Clock Event Device: pit
 
> /proc/timer_list after a boot with nohpet
> Tick Device: mode:     1
> Clock Event Device: pit

Both use PIT, so no hpet involved

> The dmesg output after a "standard" boot:

> [    0.000000] Kernel command line: root=UUID=4dc2e6b0-c980-418b-8ad0-98358e7ec47d ro quiet splash
> [    0.368027] Time: acpi_pm clocksource has been installed.

 
> The dmesg output after a boot with "nohpet"

> [    0.000000] Kernel command line: root=UUID=4dc2e6b0-c980-418b-8ad0-98358e7ec47d ro quiet splash nohpet
> [    0.368027] Time: acpi_pm clocksource has been installed.

Both boots use acpi_pm clocksource and there is nowhere a sign of HPET
in the logs except the "nohpet" on the command line.

/me is confused 

How does "nohpet" on the command line influence the behaviour, when
there is no hpet available at all.

Thanks,
	tglx


