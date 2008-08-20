Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYHTOG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYHTOG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYHTOGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:06:20 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:46310 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYHTOGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:06:19 -0400
Date: Wed, 20 Aug 2008 16:05:36 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20080820140536.GS21330@tekkaman>
References: <1219182612-13814-5-git-send-email-giometti@linux.it> <1219182612-13814-6-git-send-email-giometti@linux.it> <20080819225322.69f3215d@lxorguk.ukuu.org.uk> <20080819224930.GI21330@tekkaman> <20080819233857.41b756cc@lxorguk.ukuu.org.uk> <20080819230523.GJ21330@tekkaman> <20080820085303.GA17591@tekkaman> <20080820111117.0113da05@lxorguk.ukuu.org.uk> <20080820130124.GP21330@tekkaman> <20080820134849.GB20648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820134849.GB20648@elte.hu>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 05/10] ldisc: new dcd_change() method for line
	disciplines.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 03:48:49PM +0200, Ingo Molnar wrote:

> well, i didnt suggest you kill that aspect of the patchset - i suggested 

I see, but I agree with Alan that is better to get a first working
inclusion and then working on improments. 8)

> you change it to hook into kernel/irq/*.c instead of 
> arch/x86/kernel/irq*.c.
> 
> That way all other architectures will benefit from it, not just x86. 
> Doing an x86-only thing for such features is completely unacceptable.

I see but doing like this I can record IRQs timestamps sooner than in
kernel/irq/*.c, is that right? PPS precision is as better as sooner we
record the timestamps.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
