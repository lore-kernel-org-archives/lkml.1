Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZLGGAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZLGGAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZLGGAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:00:52 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:53797 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZLGGAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:00:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F1EY6q1hBWt+X1RHwRYkfVPTSOILuzp2wmHJJIJHCTV6gSGmCwEsDVn98vYbuQ2Kgm
         /4vnEz3GmWqJPe7xNIRo9ZnttdeCRFy+bASzwomsciGIdox7GaCbUt2mtqXsaw/U7QfG
         Sxi3rg1AqciLMvnnoovHd2MIxHVXFv1nRKyWY=
Date: Sun, 6 Dec 2009 22:00:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Message-ID: <20091207060053.GA21451@core.coreip.homeip.net>
References: <alpine.LFD.2.00.0912051635330.3560@localhost.localdomain> <200912060254.10081.rjw@sisk.pl> <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain> <20091206113555.5a646713@infradead.org> <alpine.LFD.2.00.0912061144100.3560@localhost.localdomain> <20091206121803.70385c33@infradead.org> <7AB497C7-8495-4535-9E83-81307E008BF4@gmail.com> <20091206165551.2529075f@infradead.org> <20091207022756.GB20770@core.coreip.homeip.net> <20091206212600.44806308@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206212600.44806308@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 09:26:00PM -0800, Arjan van de Ven wrote:
> On Sun, 6 Dec 2009 18:27:56 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Sun, Dec 06, 2009 at 04:55:51PM -0800, Arjan van de Ven wrote:
> > > On Sun, 6 Dec 2009 14:54:48 -0800
> > > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > 
> > > > > isn't serio the PS/2 stuff?
> > > > 
> > > > Yes, that's your PS/2 mouse (rather touchpad) and the delay comes
> > > > from device reset (needed by some keyboard controllers - I
> > > > remember HP -or it and keyboard will be dead at resume).
> > > 
> > > and I have a HP laptop... so this makes perfect sense.
> > > Thanks for the explenation!
> > > 
> > 
> > Well, we do it for everyone, it's just a particular series of HPs
> > forced us to add it.
> > 
> wonder if it should be a DMI based quirk instead...
> 

I have not received reports where it causes harm or reduces
functionality so I'd prefer having it by default and not try to race
with manufacturers.

-- 
Dmitry
