Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbYAJQik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbYAJQik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759953AbYAJQiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:38:10 -0500
Received: from mail001.aei.ca ([206.123.6.130]:56938 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759913AbYAJQiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:38:08 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Date: Thu, 10 Jan 2008 11:38:01 -0500
User-Agent: KMail/1.9.7
Cc: Matthew <jackdachef@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com> <200801100808.42945.edt@aei.ca> <20080110133252.GB5886@elte.hu>
In-Reply-To: <20080110133252.GB5886@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101138.01387.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On January 10, 2008, Ingo Molnar wrote:
> 
> * Ed Tomlinson <edt@aei.ca> wrote:
> 
> > Matthew is not alone with this problem.  I have it too.  Its not new 
> > here.  Its been happening as long as I have had gentoo amd64 
> > installed.  It can be hard to reproduce but eventually, when 32 bit 
> > apps are used, my box bricks.  There is nothing in the logs (nor on a 
> > serial console) - the box just freezes.
> > 
> > My kernel is _not_ tainted. [...]
> 
> ok, good. A series of questions:
> 
> - can you reproduce it from the VGA console?

No - though I do have a serial console to see logs.

> - if yes, does booting with "nmi_watchdog=2 idle=poll" give you a 
>   working NMI watchdog? (working NMI watchdog means the NMI counts 
>   increase for all cores in /proc/interrupts).

booting with the above gives me an incrementing NMI counter in /proc/interrupts

> if still 'yes', then try to reproduce the hard hang on the VGA text 
> console - do you perhaps get an NMI backtrace printed within 1-2 minutes 
> after the hard hang happens? If yes then take a photo of that or write 
> it down.

I am booted with the NMI watchdog and serial consoles active running apps that
eventually will trigger a hang...

Ed Tomlinson


