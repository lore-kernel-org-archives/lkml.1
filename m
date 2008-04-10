Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbYDJPhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbYDJPhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbYDJPhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:37:35 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:59105 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760418AbYDJPhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:37:34 -0400
Date: Thu, 10 Apr 2008 17:36:59 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Message-ID: <20080410153659.GF26777@enneenne.com>
References: <1207840560-24015-1-git-send-email-giometti@linux.it> <1207840560-24015-2-git-send-email-giometti@linux.it> <1207840560-24015-3-git-send-email-giometti@linux.it> <1207840560-24015-4-git-send-email-giometti@linux.it> <1207840560-24015-5-git-send-email-giometti@linux.it> <1207840560-24015-6-git-send-email-giometti@linux.it> <20080410162812.39414ec5@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410162812.39414ec5@core>
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

On Thu, Apr 10, 2008 at 04:28:12PM +0100, Alan Cox wrote:
> On Thu, 10 Apr 2008 17:15:58 +0200
> Rodolfo Giometti <giometti@linux.it> wrote:
> 
> > Adds support for the PPS sources connected with the CD (Carrier
> > Detect) pin of a serial port.
> 
> Ok why does this need to hack the driver layer ?
> 
> > -static void uart_change_speed(struct uart_state *state,
> > -					struct ktermios *old_termios);
> > +static void uart_change_speed(struct uart_state *state, struct ktermios *old_termios);
> 
> NAK. Please remove random formatting changes

Sorry, this patch is wrong! I'll re-submit the right code. '-_-

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@linux.it
Embedded Systems                     phone:	+39 349 2432127
UNIX programming                     skype:     rodolfo.giometti
