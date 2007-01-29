Return-Path: <linux-kernel-owner+w=401wt.eu-S964919AbXA2X0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919AbXA2X0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964894AbXA2X0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:26:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:3363 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964919AbXA2X0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:26:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EWLQpHdgQv6wm6CvqU3Gk7B0oBq3Mh7C6wottf5vH7YEaLuZvSE0EviEt3vSVvuXbcyjYLaKSlpxRTMw51TYTP2627USjey0bOOQnCP0WkzPXG9D7Zv4RhMMmUcUenWl7jOOg44bd/x1ycoL2ne4b7fAcd9pGD8XRy8OcNICyzg=
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: tglx@linutronix.de
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <1170111464.29240.63.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169931333.17469.125.camel@localhost.localdomain>
	 <20070129113159.7ad22e4c@freekitty>
	 <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
	 <1170109401.29240.49.camel@localhost.localdomain>
	 <1170110318.21603.25.camel@funkylaptop>
	 <1170110732.29240.59.camel@localhost.localdomain>
	 <1170111056.21603.30.camel@funkylaptop>
	 <1170111464.29240.63.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Tue, 30 Jan 2007 00:26:40 +0100
Message-Id: <1170113200.21603.41.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 janvier 2007 à 23:57 +0100, Thomas Gleixner a écrit :
> On Mon, 2007-01-29 at 23:50 +0100, Frédéric Riss wrote:
> > > That's probably a userspace problem. Are you using DHCP ?
> > 
> > Yep DHCP. Is that a known issue? I never had to reconfigure with older
> > kernels.
> 
> Is dhclient running after resume ? 

The process is of course in the process list, if that's what you mean by
'running'.

> What's the output of ifconfig (before you do ifdown/up) ? 

The output is always the same modulo the transmitted packet numbers:

eth0      Link encap:Ethernet  HWaddr 00:16:CB:A2:E4:43  
          inet addr:192.168.0.101  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::216:cbff:fea2:e443/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:269 errors:0 dropped:0 overruns:0 frame:0
          TX packets:57 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:72528 (70.8 KiB)  TX bytes:7900 (7.7 KiB)
          Interrupt:17 

The RX/TX counts are reset to 0 after a resume.

> Have you checked the syslog ?

Yes of course. Nothing interesting.

Fred.

