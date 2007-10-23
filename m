Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbXJWOGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbXJWOGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXJWOGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:06:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbXJWOF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:05:59 -0400
Subject: Re: rt73usb: support for wireless in Kohjinsha subnotebook
From: Dan Williams <dcbw@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Hazelton <dhazelton@enter.net>, Ivo van Doorn <ivdoorn@gmail.com>,
       Luis Correia <luis.f.correia@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
       mwallis@serialmonkey.com
In-Reply-To: <20071022220000.GH28190@elf.ucw.cz>
References: <20071020184100.GA11640@elf.ucw.cz>
	 <20071022211325.GF28190@elf.ucw.cz> <200710222352.57543.IvDoorn@gmail.com>
	 <200710221742.36693.dhazelton@enter.net>
	 <20071022220000.GH28190@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 10:05:12 -0400
Message-Id: <1193148312.8648.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-23 at 00:00 +0200, Pavel Machek wrote:
> Hi!
> 
> > > > Yes, I'm quite sure. There's MODULE_LICENCE("GPL"), IIRC.
> > >
> > > That doesn't say much, some manufacturers add that line to their driver
> > >  just to prevent the module loader complaining about a non-GPL driver...
> > >
> > > There should be a copyright notice or a license file accompanied with
> > > the driver that clearly states the license of the driver.
> > 
> > Lacking an explicitly stated license it can be argued that, since the 
> > MODULE_LICENSE() macro is meant to define the actual license on the code, 
> > this code is GPL. No, it isn't an explicit definition, but lacking any other 
> > signs of the license, the implicit declaration of it being GPL is (or should 
> > be) enough to deflect charges of copyright infringement.
> 
> Yep, I believe this driver is GPLed. They published the source and
> there's nothing to suggest otherwise, and there's explicit:
> 
> #define DRIVER_AUTHOR                   "Jeff Lee<YY_Lee@issc.com.tw>"
> #define DRIVER_DESC                             "IS89C35 802.11bg WLAN USB Driver"
> MODULE_LICENSE("GPL");

If there isn't an explicit COPYING or LICENSE file or something
distributed with the driver, and if there aren't copyright/license
headers at the top of the files in question, I have a hard time agreeing
that MODULE_LICENSE("GPL") _definitely_ means that the author has GPL-ed
the driver intentionally.  Of course that's the way it's supposed to
work, but to me this doesn't pass sufficient muster to be definitely
called GPL without additional clarification.

Dan


