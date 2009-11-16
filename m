Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbZKPMyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbZKPMyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZKPMyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:54:25 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:38367 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255AbZKPMyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:54:24 -0500
Message-Id: <1258376069.11110.1345439521@webmail.messagingengine.com>
X-Sasl-Enc: xc/VWKAWLq69PWG8yy/OiHICKXgjKGx9ewjGF8GQAszV 1258376069
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>
Cc: ibm-acpi-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <20091116112304.GC12315@elf.ucw.cz>
References: <20091116112304.GC12315@elf.ucw.cz>
Subject: Re: -rc6: annoying thermal messages
Date: Mon, 16 Nov 2009 10:54:29 -0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n Mon, 16 Nov 2009 12:23 +0100, "Pavel Machek" <pavel@ucw.cz> wrote:
>
> My dmesg log is rather full of. Thinkpad x60.
> Pavel

I think I will have to rate-limit it somehow.  Do we have any ready-to-
use generic rate-limiters that can do 'once a minute', or should I
cook my own?

But your thinkpad needs some sort of hardware loving care, it seems.
What does "sensors" report (or cat /proc/acpi/ibm/thermal) ?

> thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
> extremely hot!

That is a direct alarm from the firmware, the EC thinks your hardware
is damaged and about to catch fire.

Either that, or something  in the driver is seriously broken. But
you're the first one to ever report that alarm :)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

