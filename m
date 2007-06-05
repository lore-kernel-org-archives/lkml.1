Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbXFEQfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbXFEQfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764856AbXFEQfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:35:22 -0400
Received: from are.twiddle.net ([64.81.246.98]:45801 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764834AbXFEQfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:35:21 -0400
Date: Tue, 5 Jun 2007 09:32:43 -0700
From: Richard Henderson <rth@twiddle.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Meelis Roos <mroos@linux.ee>, ink@jurassic.park.msu.ru,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: alpha modpost warnings
Message-ID: <20070605163243.GA9149@twiddle.net>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Meelis Roos <mroos@linux.ee>, ink@jurassic.park.msu.ru,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0706041308560.7370@math> <20070605053502.GB21745@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605053502.GB21745@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 07:35:02AM +0200, Sam Ravnborg wrote:
> > WARNING: arch/alpha/kernel/built-in.o(.text+0x7d2c): Section mismatch:
> reference to .init.text:init_rtc_irq (between 'common_init_rtc' and
> 'timer_interrupt')

Yeah, I know about them of course.  The proper fix, as best I see it,
is to split the alpha_mv structure in two, one containing all the __init
pointers, and the other for more long term stuff.

I havn't tried to tackle this yet, as there are other more pressing 
issues, like how the glibc testsuite manages to generate soft lockups.


r~
