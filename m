Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYLBKO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYLBKO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYLBKOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:14:17 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:34346 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYLBKOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:14:16 -0500
Date: Tue, 2 Dec 2008 11:13:59 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Message-ID: <20081202101359.GB4645@gundam.enneenne.com>
References: <200811270101.mAR114rp016378@imap1.linux-foundation.org> <4930CCA9.9070505@oracle.com> <20081128220659.2d5049e6.akpm@linux-foundation.org> <49317AF9.5030409@oracle.com> <20081130215350.b63ed292.akpm@linux-foundation.org> <20081201135634.GC6932@gundam.enneenne.com> <20081201103741.f70cb84c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201103741.f70cb84c.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: mmotm 2008-11-26-17-00 uploaded (hwmon / dev_attr_name)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 10:37:41AM -0800, Andrew Morton wrote:

> I'll sort it out.

Ok. :)

> > > drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_dcd_change':
> > > drivers/pps/clients/pps-ldisc.c:32: warning: cast from pointer to integer of different size
> > > drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_open':
> > > drivers/pps/clients/pps-ldisc.c:77: warning: cast to pointer from integer of different size
> > > drivers/pps/clients/pps-ldisc.c:82: warning: cast from pointer to integer of different size
> > > drivers/pps/clients/pps-ldisc.c: In function 'pps_tty_close':
> > > drivers/pps/clients/pps-ldisc.c:91: warning: cast from pointer to integer of different size
> > > 
> > > 
> > > For the ->disc_data warnings you could perhaps just make all the
> > > relevant scalar types `long', not `int'.
> > 
> > But doing like this will breaks 32bit archs... =:-o
> 
> I don't think so.  sizeof(long) == sizeof(int) on 32-bit.

But "%d" != "%ld". :)

However this is a minor issue... I'm going to propose a patch ASAP.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
