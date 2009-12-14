Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbZLNS56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbZLNS56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbZLNS55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:57:57 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63537 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbZLNS54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:57:56 -0500
MIME-Version: 1.0
X-Originating-IP: [97.115.184.132]
Date: Mon, 14 Dec 2009 10:57:52 -0800
Message-ID: <9f53b4330912141057n52bc9331q3089ee0fb0bcbc50@mail.gmail.com>
Subject: Enhanced MMC/SD Card Power Control
From: Robert Emanuele <rob@emanuele.us>
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings once again,

Over the summer I had submitted a series of patches for the atmel-mci
driver.  One of these was for power control of each mci slot.

http://lists.arm.linux.org.uk/lurker/message/20090617.005438.eb1570d9.en.html

I'd like to resubmit this and enhance it slightly.  The current work
I'm doing is on Atmel's AT91SAM9G45.  In the patch above I include a
power control pin and the state it needs to be pulled.  I'd like to
change this to two platform defined functions for power on and power
off.  This way given which ever platform this is being used on that
platforn can concisely define how to move from a power on state to a
power off and vice versa.

For example, on my platform I would pull some GPIO high to turn off a
FET to the power of the slot and then change the function of all the
pins going to the card (except for the detect pin of course) to open
drains.  Then on power up I would do the reverse.

Given what I have described here, where would be the most logical
place to put such code?  I was assuming that it would go into the
platform configuration into the board file (board-mynewboard.c in
arch/arm/mach-at91/).

Thank you for your help and comments,

Rob
