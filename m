Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbYBERxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbYBERxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYBERxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:53:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYBERxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:53:34 -0500
Message-ID: <47A8A278.4020908@zytor.com>
Date: Tue, 05 Feb 2008 09:52:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 arch updates for v2.6.25
References: <20080130011550.GA31853@elte.hu>	<200802050436.31070.maximlevitsky@gmail.com>	<alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org> <18344.41128.159384.144803@stoffel.org>
In-Reply-To: <18344.41128.159384.144803@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
> 
> Linus> So I'd merge a patch that puts oops information (or the whole
> Linus> console printout) in the Intel management stuff in a
> Linus> heartbeat. 
> 
> How about we put in some sort of console logging tool so we can buffer
> and log the console output better?  Currently if I have both a serial
> and tty console defined, my GDM prompter looses the mouse until I goto
> the XDMCP chooser and back again.  
> 
> I'm pretty sure it's a GDM problem, since Xdm doesn't have this issue
> at all.  Haven't had time to chase it though.
> 
> In any case, having some way to log oopses better would be really
> nice.  Not sure how we could do it reliably for suspend/resume needs
> on laptops without dedicated management hardware like the ILOM stuff
> on Intel/Sun boxes.  
> 

Hm.  Dumping oops information plus perhaps even a memory dump to a USB 
key sounds like it would be highly useful - lots of storage capacity, 
readily available, and can be plugged into just about any system.

I don't know if the backdoor debugging mode in EHCI can be used for 
that.  Either way, this would have to be done *very* carefully to avoid 
clobbering USB devices not intended for this purpose.

	-hpa
