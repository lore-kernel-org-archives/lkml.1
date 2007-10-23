Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbXJWSz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbXJWSz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXJWSzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:55:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXJWSzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:55:48 -0400
Subject: Re: rt73usb: support for wireless in Kohjinsha subnotebook
From: Dan Williams <dcbw@redhat.com>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Pavel Machek <pavel@ucw.cz>, Ivo van Doorn <ivdoorn@gmail.com>,
       Luis Correia <luis.f.correia@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
       mwallis@serialmonkey.com
In-Reply-To: <200710231307.25301.dhazelton@enter.net>
References: <20071020184100.GA11640@elf.ucw.cz>
	 <20071022220000.GH28190@elf.ucw.cz>
	 <1193148312.8648.17.camel@localhost.localdomain>
	 <200710231307.25301.dhazelton@enter.net>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 14:54:54 -0400
Message-Id: <1193165694.26768.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-23 at 13:07 -0400, Daniel Hazelton wrote:
> On Tuesday 23 October 2007 10:05:12 Dan Williams wrote:
> > On Tue, 2007-10-23 at 00:00 +0200, Pavel Machek wrote:
> > > Hi!
> > >
> > > > > > Yes, I'm quite sure. There's MODULE_LICENCE("GPL"), IIRC.
> > > > >
> > > > > That doesn't say much, some manufacturers add that line to their
> > > > > driver just to prevent the module loader complaining about a non-GPL
> > > > > driver...
> > > > >
> > > > > There should be a copyright notice or a license file accompanied with
> > > > > the driver that clearly states the license of the driver.
> > > >
> > > > Lacking an explicitly stated license it can be argued that, since the
> > > > MODULE_LICENSE() macro is meant to define the actual license on the
> > > > code, this code is GPL. No, it isn't an explicit definition, but
> > > > lacking any other signs of the license, the implicit declaration of it
> > > > being GPL is (or should be) enough to deflect charges of copyright
> > > > infringement.
> > >
> > > Yep, I believe this driver is GPLed. They published the source and
> > > there's nothing to suggest otherwise, and there's explicit:
> > >
> > > #define DRIVER_AUTHOR                   "Jeff Lee<YY_Lee@issc.com.tw>"
> > > #define DRIVER_DESC                             "IS89C35 802.11bg WLAN
> > > USB Driver" MODULE_LICENSE("GPL");
> >
> > If there isn't an explicit COPYING or LICENSE file or something
> > distributed with the driver, and if there aren't copyright/license
> > headers at the top of the files in question, I have a hard time agreeing
> > that MODULE_LICENSE("GPL") _definitely_ means that the author has GPL-ed
> > the driver intentionally.  Of course that's the way it's supposed to
> > work, but to me this doesn't pass sufficient muster to be definitely
> > called GPL without additional clarification.
> >
> > Dan
> 
> Lacking any other indication MODULE_LICENSE is supposed to mark the license 
> that the code is being distributed under. If companies are intentionally

Step 1: Ask the author.

Step 2: if the author doesn't reply, then we can have this discussion

MODULE_LICENSE is just a random string that could have been added by
anybody, not necessarily the author.  Unless you can determine the
intent of the author explicitly, a single MODULE_LICENSE is not
sufficient to concretely determine the license of the code.  It's only
in one file.  There is nothing to explicitly state the overall license
of the whole work unless each file has a header referring to the license
or unless there is a license document distributed with the code as a
whole.

In the absence of any other indication, MODULE_LICENSE doesn't not
concretely determine the license of the code.  You can assume it does,
but that's your gun to put to your own head.
 
> mis-using this to get around the "internal interfaces" limitations (where 
> some interfaces are not available unless the module is GPL'd) and the warning 
> message printed in the logs when the module is not GPL'd then they are 
> (technically) in violation of the law. (interfaces that are GPL only are 
> considered so internal to the kernel that using them makes your code GPL 
> because of the inclusion of GPL'd code. And no - I am not going to get into 
> that discussion - it's pointless)

Just because the module may be loading illegally says _nothing_ about
the license of the code.

> In the end, using MODULE_LICENSE for any purpose other than declaring the 
> chosen license for the code is deceptive. So it is easily arguable that by 

"deceptive" is also not "this code code is definitely GPL".  Doesn't
matter whether it's deceptive or not.  We do not know that the code is
GPL.

> not including any license with the code other than the MODULE_LICENSE 
> statement and then trying to prosecute because MODULE_LICENSE doesn't 
> accurately state the license on the code is entrapment and illegal.

Arguable doesn't mean that it's concrete enough to pass legal muster.  I
am not a lawyer, but this just doesn't pass the bar.

Dan


