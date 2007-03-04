Return-Path: <linux-kernel-owner+w=401wt.eu-S1751583AbXCDLez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbXCDLez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 06:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXCDLez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 06:34:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34463 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXCDLez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 06:34:55 -0500
Date: Sun, 4 Mar 2007 03:34:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-Id: <20070304033445.cff1148f.akpm@linux-foundation.org>
In-Reply-To: <200703041007.31800.m.kozlowski@tuxland.pl>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<200703041007.31800.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2007 10:07:31 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> 	I'm experiencing weird system hangs with recent -mm. After a few hours of uptime for no
> obvious reason system hangs and is (almost) unusable until reset.
> 
> a few facts:
> 
> - this happens on random basis without anything obvious that could trigger it 
> - if some music is played and system hangs the music starts looping in thight loop causing weird
>   sound effects
> - sometimes I'm able to switch from X to console, it takes a few seconds to switch though
> - system is eating 100% CPU what is shown by my laptop fans
> - when I switch to console I can issue SysRq commands but they do not work i.e.:
>   SysRq + P shows only the first line: "SysRq: Show Regs"
> - in console in which I can log into the system I'm unable to type
> - in console where syslog is logging *.* I'm able to type
> - if the wifi card was plugged into the system before the hang happend the networking seems to work ok
> - when I reattach my pcmcia wifi card it doesn't get detected (nothing happens)
> - when I try to login to my laptop from remote machine the line "login:" and that's it, nothing
>   more happens
> - system logs show nothing interesting as even if there is some usable debug info I'm unable to 
>   SysRq + S and read it after reboot
> 
> With 2.6.20-mm1 it happened as well. I get the feeling that 2.6.20-rc2-mm1 needs a bit more uptime
> to hit this bug.

Thanks.  Are you sure that the kermel hasn't already oopsed when this
happens?  (netconsole will help).

The sysrq-P failure is a shame.  Does sysrq-P work as expected _before_ the
system has failed?  It sounds to me like a simple log-level thing.  Did you
try typing alt-sysrq-7 first?
