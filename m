Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYCITmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYCITmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 15:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYCITmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 15:42:44 -0400
Received: from www.tglx.de ([62.245.132.106]:58510 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYCITmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 15:42:44 -0400
Date: Sun, 9 Mar 2008 20:42:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Diego Woitasen <diego@woitasen.com.ar>
cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: BUG: High resolution timer/dynticks bug
In-Reply-To: <20080309190002.GB15058@motherbox.xtech.com.ar>
Message-ID: <alpine.LFD.1.00.0803092039140.3099@apollo.tec.linutronix.de>
References: <20080303010753.GB3512@motherbox.xtech.com.ar> <20080304110900.GA23227@elf.ucw.cz> <20080304230032.GA2967@motherbox.xtech.com.ar> <20080305082731.GA24004@atrey.karlin.mff.cuni.cz> <20080306225006.GA2972@motherbox.xtech.com.ar>
 <alpine.LFD.1.00.0803071113340.3099@apollo.tec.linutronix.de> <20080309013009.GE2972@motherbox.xtech.com.ar> <alpine.LFD.1.00.0803091623100.3099@apollo.tec.linutronix.de> <20080309190002.GB15058@motherbox.xtech.com.ar>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Diego Woitasen wrote:
> On Sun, Mar 09, 2008 at 04:42:05PM +0100, Thomas Gleixner wrote:
> > On Sat, 8 Mar 2008, Diego Woitasen wrote:
> > > > 
> > > > Is the problem reproducible when you add "hpet=disable" to the kernel
> > > > command line ?
> > > 
> > > No, with hpet=disable works fine.
> > 
> > Can you please try "processor.max_cstate=2" on the kernel command line ?
> > 
> > Also please provide a full boot log and the output of lspci -vvv
> > 
> > Thanks,
> > 
> > 	tglx
> 
> I tried. Same results, freezes after few minutes.
> 
> ----------------dmesg:

> Unknown boot option `processor.max_cstate=2': ignoring

Hmm. That probably does not work when the ACPI processor stuff is
compiled as module. Can you please compile that in via
CONFIG_ACPI_PROCESSOR=y ?

Thanks,
	tglx
