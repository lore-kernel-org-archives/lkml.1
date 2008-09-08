Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYIHU4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYIHU4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYIHU4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:56:22 -0400
Received: from www.tglx.de ([62.245.132.106]:54294 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbYIHU4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:56:21 -0400
Date: Mon, 8 Sep 2008 22:56:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefan Hellermann <stefan@the2masters.de>
cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: [regression] __tick_program_event of hpet is stuck
In-Reply-To: <48C57046.5090509@the2masters.de>
Message-ID: <alpine.LFD.1.10.0809082254550.3271@apollo.tec.linutronix.de>
References: <200809080114.36106.elendil@planet.nl> <200809080313.48910.elendil@planet.nl> <48C57046.5090509@the2masters.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, Stefan Hellermann wrote:
> Frans Pop schrieb:
> > On Monday 08 September 2008, Frans Pop wrote:
> >   
> > > With current git head (v2.6.27-rc5-319-g7686ad5) I'm seeing repeated
> > > occurrences of the following on my HP Compaq 2510p laptop. Not seen
> > > with earlier kernels, including 2.6.27-rc5.
> > >     
> > 
> > I meant repeated as in "after different boots", but I now also see repeats
> > when I leave the system on for some time. It keeps increasing the
> > min_delta_ns to ever higher values.
> > 
> > CE: __tick_program_event of hpet is stuck 1468f1b3c9 1468f1c751
> > CE: increasing min_delta_ns 5000 to 10000 nsec
> > [...]
> > CE: __tick_program_event of hpet is stuck 33576032f74 33576035684
> > CE: increasing min_delta_ns 10000 to 20000 nsec
> > [...]
> > CE: __tick_program_event of hpet is stuck 63242b30d28 63242b35b48
> > CE: increasing min_delta_ns 20000 to 40000 nsec
> > 
> > The call trace is basically the same each time.
> >   
> Exactly the same problem here. This is a Lenovo Thinkpad R61 with current git
> head (7686ad56).

Can you both please provide the full dmesg output and the out put from
lspci -vvv please ?

Thanks,

	tglx
