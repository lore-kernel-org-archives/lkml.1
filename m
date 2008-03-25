Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYCYKjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYCYKjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYCYKiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:38:52 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:51711 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbYCYKiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:38:51 -0400
Date: Tue, 25 Mar 2008 11:38:23 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com
Message-ID: <20080325103823.GD8959@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it> <12048053473401-git-send-email-giometti@linux.it> <12048053471754-git-send-email-giometti@linux.it> <12048053471177-git-send-email-giometti@linux.it> <12048053473741-git-send-email-giometti@linux.it> <12048053472063-git-send-email-giometti@linux.it> <20080320130400.0b17e1fc.akpm@linux-foundation.org> <20080321111736.GC8959@enneenne.com> <20080321104125.e1ff69c5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321104125.e1ff69c5.akpm@linux-foundation.org>
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

On Fri, Mar 21, 2008 at 10:41:25AM -0700, Andrew Morton wrote:
> On Fri, 21 Mar 2008 12:17:36 +0100 Rodolfo Giometti <giometti@enneenne.com> wrote:
> 
> > > > +#else
> > > > +
> > > > +#define uart_register_pps_port(state, port)	do { } while (0)
> > > > +#define uart_unregister_pps_port(state, port)	do { } while (0)
> > > 
> > > Please never implement in cpp that which can be implemented in C.  These
> > > should have been static inlines.  That's nicer, matches the
> > > CONFIG_PPS_CLIENT_UART=y code and provides type checking.
> > 
> > Are you saying that I should do:
> > 
> > static inline int
> > uart_register_pps_port(struct uart_state *state, struct uart_port *port)
> > {
> > 	/* Nop */
> > }
> > 
> > static inline void
> > uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
> > {
> > 	/* Nop */
> > }
> > 
> > ?
> 
> Yes please.

Fixed. I'll send a new patch ASAP.

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
