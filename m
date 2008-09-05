Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbYIEO5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbYIEO5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYIEO5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:57:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:33173 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYIEO5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:57:09 -0400
Date: Fri, 5 Sep 2008 07:57:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: frame unwinder patches
Message-ID: <20080905075703.6041650e@infradead.org>
In-Reply-To: <200809051648.52767.bs@q-leap.de>
References: <g9p3du$n95$1@ger.gmane.org>
	<200809051552.47929.bs@q-leap.de>
	<20080905071337.3373ab86@infradead.org>
	<200809051648.52767.bs@q-leap.de>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 16:48:52 +0200
Bernd Schubert <bs@q-leap.de> wrote:

> On Friday 05 September 2008 16:13:37 Arjan van de Ven wrote:
> > On Fri, 5 Sep 2008 15:52:47 +0200
> >
> > Bernd Schubert <bs@q-leap.de> wrote:
> > > > (and if you really care it's 1 line of code to turn it off)
> > >
> > > It is not only this, I think the dwarf2 stack unwinder patches
> > > provide by far better traces than the in-kernel unwinder. At least
> > > ever since I applied these patches to our kernels, I was able to
> > > read the stack dumps...
> >
> > they really wouldn't be different than the ones you get if you
> > remove the "?" lines.
> 
> Well may be, but then there is still the performace degrading, so I
> don't want to have it enabled on our production kernels. I admit I
> never measured what is the difference between of
> CONFIG_FRAME_POINTER=y and =n, but the fact the help text says there
> is a difference already makes me want to disable it (especially,
> since we have to provide benchmarks before we can sell a system).

to be honest, on 64 bit the overhead is quite small (the extra
instructions it adds are optimized for by the modern cpus that you use
in the systems you're selling); on 32 bit the overhead is.. well a
little bigger but not THAT much. yes it loses a register for the
compiler to use, but no it's not a general purpose register, and with
the register renaming that today's cpus do, I'd be surprised if you
could see anything significant.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
