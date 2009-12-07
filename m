Return-Path: <linux-kernel-owner+w=401wt.eu-S934412AbZLGC14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412AbZLGC14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 21:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933879AbZLGC1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 21:27:54 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54764 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbZLGC1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 21:27:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xgyXlye+/CSnKIP+mi0g10vv+qughtVaZgthgEiMuHzmEqPngo0FdgKAjrW4zbCkxx
         q65pitNsNWk3mIpp6MS7jwrdZcXEVKQoepq3J3gA4YdlMo9K5kToPbTfGq4WPZkdt9W0
         0p3+k/rZfn09oS/uE1s/4/vFaRZMOBhm3Jrt4=
Date: Sun, 6 Dec 2009 18:27:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Message-ID: <20091207022756.GB20770@core.coreip.homeip.net>
References: <200912052216.19540.rjw@sisk.pl> <200912060055.36130.rjw@sisk.pl> <alpine.LFD.2.00.0912051635330.3560@localhost.localdomain> <200912060254.10081.rjw@sisk.pl> <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain> <20091206113555.5a646713@infradead.org> <alpine.LFD.2.00.0912061144100.3560@localhost.localdomain> <20091206121803.70385c33@infradead.org> <7AB497C7-8495-4535-9E83-81307E008BF4@gmail.com> <20091206165551.2529075f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206165551.2529075f@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 04:55:51PM -0800, Arjan van de Ven wrote:
> On Sun, 6 Dec 2009 14:54:48 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > > isn't serio the PS/2 stuff?
> > 
> > Yes, that's your PS/2 mouse (rather touchpad) and the delay comes
> > from device reset (needed by some keyboard controllers - I remember
> > HP -or it and keyboard will be dead at resume).
> 
> and I have a HP laptop... so this makes perfect sense.
> Thanks for the explenation!
> 

Well, we do it for everyone, it's just a particular series of HPs forced
us to add it.

> Now, the good news is that serio is near invisible on resume...
> 

Resume is fully offloaded to kseriod.

-- 
Dmitry
