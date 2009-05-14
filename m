Return-Path: <linux-kernel-owner+w=401wt.eu-S1760517AbZENMJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760517AbZENMJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZENMJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:09:04 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:45170 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755940AbZENMJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:09:03 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905141208.n4EC8xh3017350@mercury.physics.adelaide.edu.au>
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
To: romieu@fr.zoreil.com (Francois Romieu)
Date: Thu, 14 May 2009 21:38:59 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org
In-Reply-To: <20090513220436.GD729@electric-eye.fr.zoreil.com> from "Francois Romieu" at May 14, 2009 12:04:36 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again

> Jonathan Woithe <jwoithe@physics.adelaide.edu.au> :
> [...]
> > I am currently testing a Gigabyte EX58-UD4P mainboard which is equipped with
> > an onboard Realtek RTL-8168D network controller.  The kernel version is
> > 2.6.29.2.  The r8169 module is loaded correctly, identifies the chip as an
> > 8168D and seemingly is happy.  However, after loading the module the link
> > remains dead.  The green and orange status LEDs remain off at all times.
> 
> Which XID does it display in dmesg when the module is inserted and which
> behavior do you experience with version 8.011.00 of Realtek's r8168 driver ?

Following up on my previous email, it seems that the stock kernel r8169
driver is now working with the card in this machine ever since I tried the
Realtek driver version 8.012.00.  It's almost as if the Realtek driver
"unlocked" something on the chip (eg: activated the PHY), the status of
which is remembered across reboots and hard powercycles.

For instance, before using the Realtek driver the green "link" LED would
never light - not during BIOS POST, Linux boot or after the respective
ethernet interface was brought up.  Now, having used the Realtek driver
once, the green "link" LED lights even during BIOS POST.  I then tested this
by removing power from the machine completely for about a minute.  When
power was restored and the PC was turned on, the green "link" LED came on
almost immediately.

Note that all this is with 2.6.30-rc5.

I'll test again tomorrow after the machine has been off for several hours.

Regards
  jonathan
