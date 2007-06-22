Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbXFVQn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbXFVQn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbXFVQm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:42:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:5011 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758892AbXFVQm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:42:56 -0400
Date: Fri, 22 Jun 2007 18:42:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Roman Zippel <zippel@linux-m68k.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Oliver Neukum <oneukum@suse.de>, linux-usb-devel@lists.sourceforge.net,
       video4linux-list@redhat.com,
       =?UTF-8?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <Pine.LNX.4.64.0706221735270.1817@scrub.home>
Message-ID: <Pine.LNX.4.64.0706221842220.26568@fbirervta.pbzchgretzou.qr>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <200706211231.53898.luca.risolia@studio.unibo.it>  <200706211326.45031.toralf.foerster@gmx.de>
  <200706211350.14526.oneukum@suse.de> <1182518566.14289.20.camel@gaivota>
 <Pine.LNX.4.64.0706221602000.1817@scrub.home>
 <Pine.LNX.4.64.0706221711320.26568@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0706221735270.1817@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 22 2007 18:24, Roman Zippel wrote:
>
>> There have been discussions to remove the default-ys again, I've sent a patch
>> [http://lkml.org/lkml/2007/5/12/216], but nothing happened.
>> 
>> So, should all affected menuconfigs be transformed into tristates, what 
>> do you think, Roman? Let me know so I can cook up a patch (hopefully 
>> before 2.6.22) should they become tristate.
>
>Using bool is clearly a bug and I'd prefer if it removed the defaults as 
>well.

What I don't quite understand is, that CONFIG_CRYPTO is also a bool,
its subparts are tristates however, and there is no problem involved
with these.


	Jan
-- 
