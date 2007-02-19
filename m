Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbXBSBuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbXBSBuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 20:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXBSBuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 20:50:05 -0500
Received: from smtp.bulldogdsl.com ([212.158.248.8]:2844 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690AbXBSBuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 20:50:03 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
Date: Mon, 19 Feb 2007 01:50:03 +0000
User-Agent: KMail/1.9.5
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org
References: <45D85DA1.7090502@xs4all.nl> <45D87BA2.9020001@xs4all.nl> <20070218193901.GN7582@csclub.uwaterloo.ca>
In-Reply-To: <20070218193901.GN7582@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702190150.03942.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 February 2007 19:39, Lennart Sorensen wrote:
[snip]
> > > On a PC, the BIOS is supposed to assign interrupts to devices based on
> > > those rules, since that is how the hardware must be done according to
> > > the PCI specifications.
> >
> > I set the BIOS for 'PnP OS installed'. Should I change that?
>
> I would NEVER do that.  That actually disables the BIOS from doing
> configuration of most hardware since it really means "Microsoft wants to
> do configuration themselves and asked us to put in a setting to make the
> bios only configure drive controllers and sound cards".  I know some
> people have worked towards making linux a "PnP OS" by microsoft
> standards, but whether it is entirely there or not by now I am not sure.
> Fortunately most motherboards I have ever bought come preset at 'pnp os
> installed' off, which is how I like it.  I have had a number of
> problems on systems with that setting on, which went away when the
> setting was set back to off.

I think this option actually _used_ to mean whether the BIOS would _provide_ 
PNP services to the host OS, allowing it to detect peripherals like parallel 
ports, etc. In reality, very few devices on modern PCs use or require BIOS 
PNP support, and in some situations it's just annoying (for example, 
disabling the parallel port on my Thinkpad has no effect because Linux just 
uses PNP to redetect it).

> It might actually work better if you change that, although it may also
> just make no difference.

In my experience it just makes no difference. I strongly doubt the option has 
_anything_ to do with this problem.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
