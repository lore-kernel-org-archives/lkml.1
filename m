Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYHTNCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYHTNCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbYHTNBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:01:45 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:40494 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbYHTNBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:01:44 -0400
Date: Wed, 20 Aug 2008 15:01:24 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20080820130124.GP21330@tekkaman>
References: <1219182612-13814-3-git-send-email-giometti@linux.it> <1219182612-13814-4-git-send-email-giometti@linux.it> <1219182612-13814-5-git-send-email-giometti@linux.it> <1219182612-13814-6-git-send-email-giometti@linux.it> <20080819225322.69f3215d@lxorguk.ukuu.org.uk> <20080819224930.GI21330@tekkaman> <20080819233857.41b756cc@lxorguk.ukuu.org.uk> <20080819230523.GJ21330@tekkaman> <20080820085303.GA17591@tekkaman> <20080820111117.0113da05@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820103115.GA3912@elte.hu> <20080820111117.0113da05@lxorguk.ukuu.org.uk>
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

On Wed, Aug 20, 2008 at 11:11:17AM +0100, Alan Cox wrote:

> Can we get the basics right first - drop the IRQ_EVENTS and HARDPPS
> hackery out of the patchset and the core code then looks quite clean.
> After that is sorted/merged we can come back to working out the best way
> to improve the IRQ and HARDPPS hacks.

On Wed, Aug 20, 2008 at 12:31:15PM +0200, Ingo Molnar wrote:

> hm, NACK on this line of approach. If then this instrumentation should 
> be done at the genirq level (kernel/irq/*.c). Also, the #ifdefs are ugly 
> - please hide them in include files.

Ok, I'll propose a new patch set without the IRQ_EVENTS part (or with
this support as last patch to be easily discarted) to get kernel
inclusion, but we had to solve this issue soon since without this
trick the PPS precision is quite low.

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
