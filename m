Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYGBOZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYGBOZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbYGBOZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:25:29 -0400
Received: from door1.ift.unesp.br ([200.145.46.252]:53249 "EHLO
	mail.ift.unesp.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752965AbYGBOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:25:28 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2008 10:25:27 EDT
Date: Wed, 2 Jul 2008 11:15:56 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: sfr@canb.auug.org.au
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: linux-next boot failure on 64-bit Sony Vaio (maybe x86 related)
Message-ID: <20080702141556.GA25441@beyonder.ift.unesp.br>
Mail-Followup-To: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
	mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

The linux-next tree for 1st of July fails to boot on my Vaio laptop, it
stops booting with the keyboard leds blinking.

I can see that there are a few backtraces printed to the screen 
before the last one, but I could only take a picture of the final
state:
http://www.ift.unesp.br/users/crmafra/failed_boot.jpg

This last warning is on arch/x86/kernel/smp.c:118 and the kernel
reports it is tainted, but I am sure it is a vanilla linux-next with
no proprietary stuff.

I could not bisect this problem yet because the first linux-next
which I tried to use was next-20080618 which had a similar boot
failure, that time at kernel/smp.c:215
http://www.ift.unesp.br/users/crmafra/failed_boot0.jpg

(I did not report it back then because I am writing my thesis and
the deadline is close...)

I used the same .config as the working 2.6.26-rc8 and I did
nothing fancy with the new config options of -next
http://www.ift.unesp.br/users/crmafra/config-failed.txt

The dmesg of 2.6.26-rc8 is here:
http://www.ift.unesp.br/users/crmafra/dmesg-good.txt

I tried to boot with 'nosmp' but it also failed.

Regards,
Carlos
