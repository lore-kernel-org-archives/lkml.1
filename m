Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbYANXVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbYANXVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 18:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYANXVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 18:21:46 -0500
Received: from relay2.netbox.cz ([83.240.0.204]:39285 "EHLO relay.netbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751314AbYANXVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:21:45 -0500
X-Greylist: delayed 879 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2008 18:21:45 EST
Date: Tue, 15 Jan 2008 02:06:10 +0100
From: Zbynek Hrabovsky <hrabosh@t-email.cz>
To: kraxel@bytesex.org
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: New type of DTV2000H TV Card
Message-Id: <20080115020610.914ec790.hrabosh@t-email.cz>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

		Hello,

first of all, sorry for my English. I've found your email address in the source code of module for CX2388X based cards. I bought Leadtek WinFast DTV2000H, but it didn't work. I found, that there are two types of this card. Type I (older), and type J (latest) ... and only type I is supported by the module.

Type J is not autodetected, and if you force card type (card = 51), DVB-T works, but there is no sound in analogue television. I know why (multiplexer, which is switching between the radio, TV, and external sound is driven by GPIO pins ... and setting of this pins is wrong), and I wrote a patch, which makes this card (DTV2000H type J) works. 

With this patch, card is autodetected, I'm having sound in analogue television, I can switch between antenna, and cable signal input, and I can see video from external S-video and composite video input.

So ... do you want me to send this patch to you ? I think it will be good to add support for this card to the cx88xx module.

Bye,
	Zbynek Hrabovsky, Brno, Czech Republic
