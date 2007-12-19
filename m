Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbXLSXxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbXLSXxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbXLSXxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:53:10 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50186 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428AbXLSXxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:53:09 -0500
X-Greylist: delayed 1302 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2007 18:53:09 EST
X-Sasl-enc: 5XUmOk4YaTVNYTrFcNr8ARfH0AAHXXiG9BdaRuRPajxA 1198107086
Subject: RE: printf internals
From: Scott Russell <catfather@donpoo.net>
To: Siva Prasad <sprasad@bivio.net>
Cc: Clemens Koller <clemens.koller@anagramm.de>,
       David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org
In-Reply-To: <D83235F0F3C86D4D889D8B9A0DA8C6D7012AF540@corpexc01.corp.networkrobots.com>
References: <D83235F0F3C86D4D889D8B9A0DA8C6D7011A8217@corpexc01.corp.networkrobots.com>
	 <4761E289.9070007@davidnewall.com> <4762AC35.3010706@anagramm.de>
	 <D83235F0F3C86D4D889D8B9A0DA8C6D7012AF540@corpexc01.corp.networkrobots.com>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 18:31:25 -0500
Message-Id: <1198107085.7740.0.camel@oasis.donpoo.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-19 at 14:33 -0800, Siva Prasad wrote:
> Thank you very much for your response Clemens.
> 
> I tried strace on a regular system. It does not show which tty, etc., as it uses the stdout (fd = 1) and write(1, ...) to it.
> 
> This is not a student project. I am trying to build my own kernel and ramdisk. Kernel boots fine to a point where it starts accessing ramdisk and executes init scripts. From there on nothing gets printed. I did some debugging and found that prints of user land programs are not coming to the serial console, while kernel prints are working fine. I found all the programs getting executed, by placing a printk in execve routine and printing the arguments.
> 
> So, I wanted to trace down the path from user program to the kernel and see why it is not printing messages from user program. I placed a printk in drivers/char/tty_io.c:tty_write() and it is not getting called from my file system. I tried the same thing on my good system (say regular PC) and it works as expected.
> 
> Any clues that can help debug this issue is highly appreciated.
> How can I get access to the same printf string inside kernel.

This sounds like you're printing out the serial console instead.

-- 
Scott <catfather@donpoo.net>
AIM: BlueCame1

