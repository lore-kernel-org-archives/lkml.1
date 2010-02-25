Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799Ab0BYU5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:57:53 -0500
Received: from smtp.seznam.cz ([77.75.76.43]:49488 "EHLO smtp.seznam.cz"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933787Ab0BYU5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:57:51 -0500
X-Greylist: delayed 726 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Feb 2010 15:57:50 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=post.cz;
	h=Received:From:To:Date:MIME-Version:Subject:Message-ID:Priority:X-mailer:Content-type:Content-transfer-encoding:Content-description:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=dq1fzjThHIsq7MfGpdvzFDcYnSlwlC9YhgRQySmpA6FXWjToMzgT+IBH9hcsTNKHW
	Rb4EAVK+4M9Bp9rDegDLhjLtgehpQZQpXK+mvSOEYkmFOAYjMHQPeuoMgkRTjgy0fu0
	mY0avze09YxPcDWMQyCFZFnr9RaDfmmUfpx6bzM=
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Thu, 25 Feb 2010 21:45:41 +0100
MIME-Version: 1.0
Subject: Dynticks on Vortex86SX ? (Cx486SLC + just the standard i8254 PC timer)
Message-ID: <4B86EF85.12688.440738@Frantisek.Rysanek.post.cz>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.1.7@13984
X-Seznam-User: frantisek.rysanek@post.cz
X-QM-Mark: email-qm4<421186796>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gentlemen,

I'm having fun with a Vortex-based motherboard, under 2.6.33.
Linux reports the CPU as a Cx486SLC :-)
A complete PC-compatible motherboard (without VGA) running at ~ 2 
Watts.
I'm wondering how to decrease the power consumption even further,
and "tickless" operation comes to mind.
And that's where I have a problem. Even if I enable 
"Tickless System (Dynamic Ticks)" in the menuconfig,
there's no apparent change in consumption, and I still get 
around 200-300 timer interrupts per second...

These are some entries from my .config that might be relevant:

CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_M486=y
CONFIG_HZ_250=y
CONFIG_HZ=250

The only timer that this platform contains (known to Linux)
is the generic i8254-compatible PC timer.

Makes me wonder if this platform is capable of "tickless" operation
at all. Or maybe my particular combination of features in the .config
effectively prevents the long idle periods from occurring?

Apart from a standard init and getty's, there's a dhclient and sshd 
running on the machine... it's a fairly minimal text-mode system.

Any ideas are welcome :-)

Frank Rysanek

