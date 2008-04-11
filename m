Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbYDKItS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYDKItS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbYDKItK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:49:10 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:43294 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbYDKItJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:49:09 -0400
Date: Fri, 11 Apr 2008 10:49:03 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Message-ID: <20080411084903.GK26777@enneenne.com>
References: <20080410160630.GA24885@enneenne.com> <1207851751-25703-1-git-send-email-giometti@linux.it> <1207851751-25703-2-git-send-email-giometti@linux.it> <1207851751-25703-3-git-send-email-giometti@linux.it> <1207851751-25703-4-git-send-email-giometti@linux.it> <1207851751-25703-5-git-send-email-giometti@linux.it> <1207851751-25703-6-git-send-email-giometti@linux.it> <20080410210918.3be98868@core> <20080411075515.GH26777@enneenne.com> <20080411092840.3cc4de67@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411092840.3cc4de67@core>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 5/7] PPS: serial clients support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 09:28:40AM +0100, Alan Cox wrote:
> > How can I do that? From a serial device I just need the IRQ time
> > arrival, no other data at all. How a ldisc can help me in this task?
> 
> At the moment you can't. That needs fixing. Most of the infrastructure is
> there but not all of it.
> 
> > This patch adds PPS support just for UARTs, other devices should
> > provide their own support by using the new provided API. :)
> 
> I do not want PPS code adding to every single serial driver. That way
> lies madness. We do it once, and in the right layer. I'll take a further

The problem is that deferencing the pps_event() call will cause severe
problems to PPS accuracy... here you can find some considerations on
this topic:

   http://ml.enneenne.com/pipermail/linuxpps/2008-April/001738.html

> look at it after the tty->ops patch is merged. At that point we'll be in
> a good position to add the needed ops/callbacks.

Can you please give me an URL where I can see that patch?

Thanks a lot for your help,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@linux.it
Embedded Systems                     phone:	+39 349 2432127
UNIX programming                     skype:     rodolfo.giometti
