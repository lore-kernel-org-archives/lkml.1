Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYK1M6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYK1M6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 07:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYK1M5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 07:57:51 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:54991 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYK1M5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 07:57:50 -0500
Date: Fri, 28 Nov 2008 13:57:22 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Message-ID: <20081128125722.GL13891@tekkaman>
References: <1227647470-4816-1-git-send-email-giometti@linux.it> <1227647470-4816-2-git-send-email-giometti@linux.it> <492FD864.50901@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492FD864.50901@imap.cc>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] ldisc: new dcd_change() method for line disciplines.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 12:39:16PM +0100, Tilman Schmidt wrote:
> Rodolfo Giometti schrieb:
> > --- a/include/linux/tty_ldisc.h
> > +++ b/include/linux/tty_ldisc.h
> > @@ -99,11 +99,19 @@
> >   *	cease I/O to the tty driver. Can sleep. The driver should
> >   *	seek to perform this action quickly but should wait until
> >   *	any pending driver I/O is completed.
> > + *
> > + * void (*dcd_change)(struct uart_port *port, unsigned int status,
> > + * 			struct timespec *ts)
> > + *
> > + *	Tells the discipline that the DCD pin has changed its status and
> > + *	the relative timestamp. Pointer ts can be NULL.
> >   */
> 
> I don't see an actual call to that new method getting added anywhere.
> Is that planned for a later patch? Which serial drivers will support
> that mechanism? Should the documentation perhaps mention that not
> all drivers support this?

See patch pps-serial-clients-support.patch into this patchset.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
