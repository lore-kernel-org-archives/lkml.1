Return-Path: <linux-kernel-owner+w=401wt.eu-S1752448AbYJ0Ip2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbYJ0Ip2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYJ0IpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:45:20 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13907 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYJ0IpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:45:19 -0400
Date: Mon, 27 Oct 2008 09:45:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mike Rapoport <mike@compulab.co.il>, Eric Miao <eric.miao@marvell.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: CONFIG_LEDS_DA903X=m breaks 2.6.28-rc2-git1 build on x86-64
Message-ID: <20081027094509.302401e4@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike, Eric, Richard,

With CONFIG_LEDS_DA903X=m, kernel 2.6.28-rc2-git1 fails to build on
x86-64 with the following error:

  CC [M]  drivers/leds/leds-da903x.o
drivers/leds/leds-da903x.c:35: error: field "work" has incomplete type
drivers/leds/leds-da903x.c: In function "da903x_led_work":
drivers/leds/leds-da903x.c:47: warning: type defaults to "int" in declaration of "__mptr"
drivers/leds/leds-da903x.c:47: warning: initialization from incompatible pointer type
drivers/leds/leds-da903x.c: In function "da903x_led_set":
drivers/leds/leds-da903x.c:89: error: implicit declaration of function "schedule_work"
drivers/leds/leds-da903x.c: In function "da903x_led_probe":
drivers/leds/leds-da903x.c:125: error: implicit declaration of function "INIT_WORK"

Can we PLEASE stick to the plan and ONLY have bug FIXES after rc1 (and
even more so after rc2)?

Thanks,
-- 
Jean Delvare
