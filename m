Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbYFYQg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbYFYQg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYFYQgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:36:21 -0400
Received: from the2masters.de ([213.146.113.64]:44738 "EHLO
	smtp.the2masters.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYFYQgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:36:20 -0400
Subject: Re: strange freeze with VIA C7 dedicated server and libc 2.6.1
From: Stefan Hellermann <stefan@the2masters.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: william <william@waisse.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080624222859.1e12dc2d@lxorguk.ukuu.org.uk>
References: <2ffbcf00806232001o4bd314f4kc590e43b4ab27076@mail.gmail.com>
	 <20080624102129.19d79eb0@lxorguk.ukuu.org.uk>
	 <2ffbcf00806241405w5b757b56p84cd560166ea8f90@mail.gmail.com>
	 <20080624222859.1e12dc2d@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 18:36:11 +0200
Message-Id: <1214411771.2793.22.camel@hel-stefan.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 24.06.2008, 22:28 +0100 schrieb Alan Cox:
> > * the watchdog says nothing in the logs, but is able to reboot the box.
> > 
> >  Thank you very much for your answer Alan, I were hesitating on
> > posting a report with no logs, no clues . . . your answer gives me a
> > little hope ;)
> 
> Two random thoughts from your last comment
> 
> - If you do
> 
> echo "2" >/proc/sys/vm/overcommit_memory
> echo "80" >/proc/sys/vm/overcommit_ratio
> 
> do you instead get out of memory kills (which would imply bad memory
> leaks perhaps triggered by glibc ?)
> 
> - Does your system pass 'crashme' testing (run as a non root user). If
> not then that might give an eventual identification of a crashme run
> which takes out the box. We've found kernel bugs, CPU bugs and
> combinations of the two before now that way.

Hi!

I've got the same problem with a VIA Epia SN-1800, Gentoo and
glibc-2.6.1. First I had crashes every day, but these came from
madwifi-ng. Now with vanilla-2.6.25.6 and no modules it's crashing about
every 3 weeks with no log I can provide. I have a serial console
connected to it, but I have no other device running 24h to collect the
crash.
I tried glibc-2.7, but with this powerdns-resolver isn't working any
more, and I don't think the problems are gone (only one crash so far).
It's not easy to downgrade glibc on gentoo, but I could try
vanilla-glibc-2.5 if this would help.
I have no big crontab, only a script with rotates logs and makewhatis.

Where can I find 'crashme'? Is it a tool I can download?

It's a small home-server carrying my mails and webspace, so I can do a
bit testing, but I don't like large downtime :-)

-- 
Kind Regards
Stefan Hellermann

