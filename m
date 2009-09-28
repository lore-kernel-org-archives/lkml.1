Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZI1D2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZI1D2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 23:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZI1D2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 23:28:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:39579 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbZI1D2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 23:28:13 -0400
Subject: Re: Status of Regression/Bug 13407 adb trackpad disappears after
 suspend to ram?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Martin Wache <m.wache@gmx.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <4ABFAA82.2040200@gmx.net>
References: <4ABF5432.9020508@gmx.net> <200909271713.44719.rjw@sisk.pl>
	 <4ABFAA82.2040200@gmx.net>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 13:27:47 +1000
Message-Id: <1254108467.8421.3.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-27 at 20:10 +0200, Martin Wache wrote:
> Hi,
> 
> Rafael J. Wysocki schrieb:
> 
> > A patch has been submitted which is reported to fix the issue:
> > 
> > http://patchwork.kernel.org/patch/49462/
> > 
> > Please test it as requested.
> >
> Thank you for the info :-)
> 
> Unfortunately, applying the patch on top of 2.6.31 doesn't improve the 
> situation for me, rather the opposite. Under X I get no reaction on any 
>   keypress on the keyboard or movement on the trackpad. Even plugging in 
> an USB mouse and keyboard didn't help, the usb port doesn't provide an 
> power to the mouse (at least the led in the mouse doesn't light up).
> Before X starts up the keyboard does respond, also the trackpad seems to 
> be detected. Doing a suspend/resume cycle doesn't change the situation.

That looks like a different problem than the one I fixed. Is there an
email thread or a bugzilla entry that describes the setup precisely, the
symptoms, kernel logs etc... ?

> I'm not sure if there was a miscompilation, I didn't do a "make clean", 
> I just applied the patch and did a "make". Should this be enough? 
> Compiling the whole kernel unfortunately takes quite a while on my iBook :-(
> I will see if I can connect to the iBook via net and get some 
> information on what is happening, or maybe I try to start it up without 
> X. Would it help you if I send you the logs, etc? Which information 
> would help you?

Start with sending the dmesg, the output of cat /proc/cpuinfo, and the
Xorg log (/var/log/Xorg.0.log)

Cheers,
Ben.

> Thanks,
> 
> Martin

