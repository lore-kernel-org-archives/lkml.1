Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbXFDPmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbXFDPmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbXFDPmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:42:13 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:57225 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812AbXFDPmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:42:11 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Antonio Mignolli" <antoniomignolli@gmail.com>
Subject: Re: lid switch hangs notebook
Date: Mon, 4 Jun 2007 09:42:07 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <a790ea7a0703120753i232ace2bg7272fa479b821e32@mail.gmail.com> <200704131553.54787.bjorn.helgaas@hp.com> <a790ea7a0706040357g799e8756ue758e95d5b460307@mail.gmail.com>
In-Reply-To: <a790ea7a0706040357g799e8756ue758e95d5b460307@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706040942.07661.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 04:57:21 am Antonio Mignolli wrote:
> The problem reported below has not been solved,
> I tried with the last stable kernel 2.6.21.3.
> 
> But it seems not to be an ACPI issue,
> I removed ACPI support from the kernel,
> and still have the problem.
> What else could be?

The lid switch event is probably reported via ACPI.  But the
fact that you see your "LID switch" message from /etc/acpi/acpi_handler.sh
means the switch event is getting through.

What else does the acpi_handler.sh script do?  Can you add more
log messages in it and any related scripts?

If all else fails, you could try git-bisect to isolate a changeset
that broke it.  That's tedious but usually effective.

Bjorn

> On 4/13/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > On Thursday 15 March 2007 13:06, Andrew Morton wrote:
> > > > On Mon, 12 Mar 2007 15:53:18 +0100 "Antonio Mignolli" <antoniomignolli@gmail.com> wrote:
> > > > Hi,
> > > > I'm running a slackware 10.2 on a HP/Compaq nx5000.
> > > >
> > > > With kernels <= 2.6.17.3 I didn't have problems.
> > > > Starting from 2.6.19 if I close the notebook's video,
> > > > or if I press the lid switch,
> > > > after a couple of time, or after a few seconds, the o.s. hangs
> > > > completely. The only thing to do is a brute power off
> > > > by pressing for 5 seconds the power button
> > > > (If I press for few it should do a clean shutdown -h).
> > > > I've tried 2.6.19, 2.6.19.1, 2.6.19.2, 2.6.20, 2.6.20.1, 2.6.20.2,
> > > > and all of them seem to give problems.
> > > >
> > > > I don't have KERNEL_DEBUG set, so I haven't any debug informations,
> > > > I will be happy to activate it and provide more info if someone suggests
> > > > me which debug parameters I should set.
> > > > There's nothing in /var/log/messages and /var/log/syslog,
> > > > except for the message "LID switch" added by me
> > > > with a logger command in /etc/acpi/acpi_handler.sh.
> > > > I've put it after noticing the problem, in order to be sure the event was
> > > > detected, and it was.
> > >
> > > I guess this is an ACPI think, although not necessarily.
> > >
> > > Len & co: do you think we should ask Antonio to raise a report
> > > against ACPI at bugzilla.kernel.org?
> >
> > I don't see a response to this on the linux-acpi list.  Did the
> > problem get resolved?
> >
> 


