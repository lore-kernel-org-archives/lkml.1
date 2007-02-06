Return-Path: <linux-kernel-owner+w=401wt.eu-S965605AbXBFXzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965605AbXBFXzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965606AbXBFXzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:55:00 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38496
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965605AbXBFXy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:54:59 -0500
From: Rob Landley <rob@landley.net>
To: dwalker@mvista.com
Subject: Re: 2.6.20-rc6-mm3
Date: Tue, 6 Feb 2007 18:55:04 -0500
User-Agent: KMail/1.9.1
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu
References: <20070129204528.eb8d695e.akpm@osdl.org> <200702061815.41078.rob@landley.net> <1170804518.3455.115.camel@dwalker1>
In-Reply-To: <1170804518.3455.115.camel@dwalker1>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702061855.05020.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 February 2007 6:28 pm, Daniel Walker wrote:
> On Tue, 2007-02-06 at 18:15 -0500, Rob Landley wrote:
> > On Tuesday 06 February 2007 3:40 pm, Daniel Walker wrote:
> > > In this case "different" goes into userspace .. So different could mean
> > > userspace regression, which is something that we don't want. I have no
> > > idea if any apps use /proc/interrupts , but it's possible since it's
> > > been around for a long time.
> > > 
> > > The reason that I'm bringing it up at all is because people have ask me
> > > "Why isn't my timer ticking??"

Ah, you can't answer this question.  Right:

A) Because there are multiple timer interrupt sources in the system, and we're 
now using a newer (better) one.

B) This measures interrupts.  It doesn't measure jiffies.  Interrupts != 
jiffies.  This is a conceptual issue.

C) /proc/uptime may be of use here.

> > Because there are two clock sources in the machine and it's using the 
other 
> > one, so the interrupt isn't firing?
> > 
> > Are you saying that the /proc statistics aren't accurate, or that you 
> > previously misunderstood what it was actually measuring and you'd now like 
it 
> > to lie?
> 
> I understand exactly what is happening . The statistics are unclear, and
> tend to confuse people .

You find /proc/interrupts showing interrupts to be _unclear_?

> Daniel

Rob
-- 
"Perfection is reached, not when there is no longer anything to add, but
when there is no longer anything to take away." - Antoine de Saint-Exupery
