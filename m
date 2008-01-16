Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYAPOgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYAPOgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 09:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYAPOg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 09:36:28 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41568 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbYAPOg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 09:36:27 -0500
Message-ID: <478E1668.9040404@davidnewall.com>
Date: Thu, 17 Jan 2008 01:06:24 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: David Woodhouse <dwmw2@infradead.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	 <200801081810.58904.linux@rainbow-software.org> <4783B1B2.6070005@reed.com>	 <200801081838.16241.linux@rainbow-software.org> <4783C4A6.9060402@reed.com>		 <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk> <4783CBD9.7020709@reed.com>	 <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>	 <47845972.9090803@zytor.com>	 <1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>	 <47854916.4080703@reed.com>	 <1200015388.6192.22.camel@bodhitayantram.eng.vmware.com>	 <4786DD05.20804@keyaccess.nl>  <47877ECD.9060408@reed.com> <1200347847.2647.97.camel@shinybook.infradead.org> <478BE08B.3090306@reed.com>
In-Reply-To: <478BE08B.3090306@reed.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> I think we probably have a great shot at getting Intel, Microsoft, HP,
> et al.. to add a feature for Linux to one of the ACPI table
> specifications that define an "unused port for delay purposes" field
> in the ACPI 4.0 spec, and retrofit it into PC/104 machine BIOSes.  At
> least Microsoft doesn't have a patent on using port 80 for delay
> purposes. :-) 

This use of port 80 (or insert some other random number) is a croc of
hackery of the most inexperienced kind.  The task to be performed is to
delay for some period, and I think it's a mix of bloody mindedness and
fear of unfamiliar code and specification that explains why a delay is
not being coded.  Lest we forget, someone who should know better said
that an OUT is used because you don't know how long the delay should be
on any specific machine.  What rubbish.

For what it's worth, I would oppose any attempt to ammend ACPI
specifications in the way described above.  It's bad enough to have that
embarrassing and unseemly hack in Linux.  It would be so much worse to
enshrine the practice as industry standard practice.

I won't even mention the many instances of these delays where no delay
is what properly is needed.  Performance?  Who cares about performance?
