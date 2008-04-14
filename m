Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbYDNAkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbYDNAkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYDNAkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:40:01 -0400
Received: from rv-out-0708.google.com ([209.85.198.250]:7367 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752968AbYDNAj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lSdE8XgIBCuSki4nG+QtoCSsq8AZ5CVfMYQzRoYmsxR37Qupq0WRqdqXNLANyW0Kw3zASbKbfTWZsC/8w5XdOs47o977u+0F/k4ZiPT6KLgRza5PF08JB6vc6yuJN62xEXNGVJ6Va2nwQJMck9q5x/Oby4YL6f4oZQBasIE4FgI=
Subject: Re: sata_via
From: Tejun Heo <htejun@gmail.com>
To: Rich West <Rich.West@wesmo.com>, Thomas Renninger <trenn@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>,
       Wander Winkelhorst <w.winkelhorst@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
In-Reply-To: <48018DC0.6080407@wesmo.com>
References: <47F694C8.8020507@wesmo.com> <47F6A5E8.1030602@garzik.org>
	 <47F6BD55.3090708@wesmo.com>
	 <5699f8f00804050015kb1ebb1cpf3ab8b587580fffd@mail.gmail.com>
	 <47F7982E.5080701@wesmo.com> <47F7F463.2060402@garzik.org>
	 <480173CB.5070805@gmail.com> <480189DB.9050900@wesmo.com>
	 <48018DC0.6080407@wesmo.com>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 09:39:47 +0900
Message-Id: <1208133587.2755.8.camel@htj.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2008-04-13 at 00:36 -0400, Rich West wrote:
> Rich West wrote:
> > Tejun Heo wrote:
> >> Jeff Garzik wrote:
> >>> Rich West wrote:
> >>>> I was only curious as to what turning off power management support 
> >>>> would buy with regard to the sata timeout issue.
> >>>
> >>>
> >>> ACPI is not only power management.  It is all the information your 
> >>> hardware conveys to your OS, about the setup and workings of your 
> >>> hardware.
> >>>
> >>> Without ACPI, non-PM things like SMP, laptop dock/undock, and many 
> >>> other gadgets fail to function (or are configured sub-optimally).
> >>>
> >>> ACPI sets up interrupt routing, and Linux history is _loaded_ with 
> >>> _years_ of problem reports that appear as timeouts, only to be 
> >>> resolved as ACPI interrupt bugs (aka BIOS bugs, since ACPI tables 
> >>> come from BIOS).
> >>
> >> Also, please give a shot at the sacred "irqpoll".
> >
> > I've had bad luck in the past (with other machiens) when adding 
> > "irqpoll" in that it had locked up the entire machine (not this one, 
> > but others) after a very short period of time.  My only attempt at 
> > using it, though, was to try to address an X server related issue, but 
> > this is a non-user machine, so X isn't necessary, and, hence, it's at 
> > runlevel 3 all of the time.
> >
> > So far, noapic and acpi=off seem to be working.. The system has been 
> > up 8 days without any problems.. previously, a problem with the SATA 
> > drive (details of which were part of the first few messages in this 
> > thread) would surface anywhere between 15 minutes and 5-7 days after a 
> > reboot.
> >
> > However, since I started this email, I tried firing up X (with noapci 
> > and acpi=off both set), the machine locks up entirely.
> 
> Although a reboot with irqpoll set managed to fix that X problem. :)
> 

IRQ routing seems hosed on your machine.  Thomas any ideas?

-- 
tejun

