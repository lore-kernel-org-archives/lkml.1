Return-Path: <linux-kernel-owner+w=401wt.eu-S1765820AbYDQRH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765820AbYDQRH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbYDQRHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:07:11 -0400
Received: from mail.suse.de ([195.135.220.2]:55056 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbYDQRHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:07:09 -0400
Date: Thu, 17 Apr 2008 10:02:52 -0700
From: Greg KH <gregkh@suse.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Spanton <rspanton@zepler.net>
Subject: Re: USB: serial: ti_usb_3410_5052: Correct TUSB3410 endpoint
	requirements.
Message-ID: <20080417170252.GB27929@suse.de>
References: <20080417010122.148289106@sous-sol.org> <20080417010337.278890290@sous-sol.org> <200804171001.59496.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804171001.59496.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 10:01:57AM +0200, Oliver Neukum wrote:
> Am Donnerstag, 17. April 2008 03:01:46 schrieb Chris Wright:
> > -stable review patch.  If anyone has any objections, please let us know.
> > ---------------------
> > 
> > From: Robert Spanton <rspanton@zepler.net>
> > 
> > upstream commit: 1bfd6693cd66f1e79abce62d3e8c3647e1f59a55
> > 
> > The changes introduced in commit
> > 063a2da8f01806906f7d7b1a1424b9afddebc443 changed the semantics of the
> > num_interrupt_in, num_interrupt_out, num_bulk_in and num_bulk_out
> > entries of the usb_serial_driver struct to be the number of endpoints
> > the device has when probed.
> 
> Greg, your last patch to 2.6.25-rc9 should have obsoleted this patch.

Yes, but it came in too late :(

> Should your patch be included instead of this patch and
> "USB: serial: fix regression in Visor/Palm OS module for kernels >= 2.6.24" ?

This one is safe enough for now, the other patch has already been sent
to stable@ so it will go into the next 2.6.24 kernel release.

thanks,

greg k-h
