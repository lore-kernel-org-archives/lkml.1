Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbYDKQ7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbYDKQ7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760740AbYDKQ6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:58:54 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:52163 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760604AbYDKQ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:58:53 -0400
Date: Fri, 11 Apr 2008 18:58:36 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Message-ID: <20080411165836.GY26777@enneenne.com>
References: <1207851751-25703-2-git-send-email-giometti@linux.it> <1207851751-25703-3-git-send-email-giometti@linux.it> <1207851751-25703-4-git-send-email-giometti@linux.it> <1207851751-25703-5-git-send-email-giometti@linux.it> <1207851751-25703-6-git-send-email-giometti@linux.it> <20080410210918.3be98868@core> <20080411075515.GH26777@enneenne.com> <20080411092840.3cc4de67@core> <20080411084903.GK26777@enneenne.com> <87prsw78qs.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87prsw78qs.fsf@depni.sinp.msu.ru>
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

On Fri, Apr 11, 2008 at 06:43:07PM +0400, Serge Belyshev wrote:
> Rodolfo Giometti <giometti@enneenne.com> writes:
> 
> > The problem is that deferencing the pps_event() call will cause severe
> > problems to PPS accuracy... here you can find some considerations on
> > this topic:
> >
> >    http://ml.enneenne.com/pipermail/linuxpps/2008-April/001738.html
> >
> 
> What about adding precise timestamping to the lowest possible irq
> handling level ( arch/*/entry*.S ) and then export that information
> in a general way so it is useful for other applications?

The problem is that at such level you cannot easily retrieve info
about where your serial port is connected to and which PPS source you
should manage...

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@linux.it
Embedded Systems                     phone:	+39 349 2432127
UNIX programming                     skype:     rodolfo.giometti
