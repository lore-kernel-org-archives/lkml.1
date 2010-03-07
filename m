Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0CGUmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 15:42:19 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60170 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0CGUmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 15:42:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GP/BHZOVQk3hrBDY75RM0XPzkJ8PThuksesGBotlF7zj0m0/06j7m64o06nO2vWE93
         wapHA5mkbCeVgolxHmAUSQGMjXniC8HjBPnP4lnE3YeFPE8XuudnhRlcYCabD4rgNAJM
         rcpw2c3/qvRuWDpxjRYPs824eBvxd1luMedx8=
Date: Sun, 7 Mar 2010 12:42:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100307204213.GB17727@core.coreip.homeip.net>
References: <4B8C1867.7040201@cam.ac.uk>
 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
 <20100303184132.GA11471@core.coreip.homeip.net>
 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
 <20100303190753.GB11471@core.coreip.homeip.net>
 <404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com>
 <alpine.LFD.2.00.1003031348510.3599@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003031348510.3599@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 01:51:07PM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 3 Mar 2010, Dima Zavin wrote:
> > 
> > Actually, accelerometers fit into that model fine. They have some
> > variable number of absolute axes (3, 6, etc.).
> 
> In fact, they obviouslya also do end up being used exactly like joysticks 
> in real life, and joysticks are commonly starting to have accelerometers 
> in them (ie any modern game console controller).
> 
> So treating an accelerometer like a joystick - regardless of whether it 
> happens to be internal to the device or happens to be external in a 
> separate controller - is not all that far-fetched anyway.
> 

But the point is that not every accelerometer is a joystick. We have
hdaps and friends that have accelerometers inside but that is not their
main purpose (they do export a secondary joystick-like interface and
that is fine), and I am pretty sure that there are other users of
accelerometers in various systems.

I am retty sure that once we settle on the proper interface for such
sensors we should be able to write a bridge to input layer so they can
be easily used as [human] input devices in cases whether it is desired.

-- 
Dmitry
