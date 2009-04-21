Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbZDUQZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbZDUQZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbZDUQY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:24:57 -0400
Received: from smtp.witbe.net ([81.88.96.48]:36949 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbZDUQYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:24:49 -0400
Date: Tue, 21 Apr 2009 18:24:48 +0200
From: Paul Rolland <rol@as2917.net>
To: linux-kernel@vger.kernel.org
Subject: linux-2.6.30-rc2 - No sound (HDA Intel) avec resume
Message-ID: <20090421182448.270f0e10@tux.DEF.witbe.net>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.8; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

For the first time, I can successfully suspend/resume my Dell laptop using
linux 2.6.30-rc2.
Unfortunately, after resume, xmms stays silent. I've tried to change the
master channel, and everything I can access in the configuration, but no
luck.
All other devices are resuming correctly, including the video while running
X and compiz, so this is quite good.

Is there anything I can do to help on this issue ?

At boot time, I have :
Advanced Linux Sound Architecture Driver Version 1.0.19.
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
HDA Intel 0000:00:1b.0: setting latency timer to 64
ALSA device list:
  #0: Dummy 1
  #1: Virtual MIDI Card 1
  #2: HDA Intel at 0xefebc000 irq 21

When suspending :
Apr 20 21:26:21 tux kernel: HDA Intel 0000:00:1b.0: PCI INT A disabled

When resuming :
Apr 20 21:26:21 tux kernel: HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21

Regards,
Paul
