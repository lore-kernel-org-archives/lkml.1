Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbYHaHRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbYHaHRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 03:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYHaHRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 03:17:34 -0400
Received: from swm.pp.se ([212.247.200.143]:35093 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbYHaHRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 03:17:33 -0400
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Aug 2008 03:17:33 EDT
Date: Sun, 31 Aug 2008 08:55:09 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-kernel@vger.kernel.org
Subject: 2.6.2[67] unexpected IRQ trap at vector 9c
Message-ID: <alpine.DEB.1.10.0808310833490.15314@uplift.swm.pp.se>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello.

I have a VIA SN motherboard and I am having trouble with a nvidia 6200LE 
under 2.6.2[67]. I have tried 2.6.26.3 (kernel.org kernel I compiled 
myself), ubuntu 8.10 alpha4 supplied 2.6.26 and 2.6.27 kernels, all 
exhibit the same problem.

Ubuntu 8.04 supplied 2.6.24 kernel works fine.

My nvidia 7600GT works fine with all above kernels. I borrowed a nvidia 
8500GT as well, it shows the same symptoms as the 6200LE.

Here are pictures from the bootup, this is scrolling past very quickly so 
I took a picture as I couldn't gather the text in log form (the kernel 
won't boot):

<http://swm.pp.se/irq/IMG_0039-s.jpg>
<http://swm.pp.se/irq/IMG_0041-s.jpg>

I don't remember which kernel/hardware combination showed which output, 
but if it's important I can find out.

My hardware specs can be seen at URL below (in the end there are lspci 
etc). This case is regarding another issue I am having with the ubuntu 
installer, but all the same, it hopefully includes enough relevant 
information regarding my hardware...

<https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-nv/+bug/158018>

Link to the motherboard specs at Via:

<http://www.via.com.tw/en/products/mainboards/motherboards.jsp?motherboard_id=550>

Any idea what's going on and how I can proceed in further diagnosing the 
problem?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
