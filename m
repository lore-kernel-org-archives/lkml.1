Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbXBWXwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbXBWXwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932791AbXBWXwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:52:22 -0500
Received: from ns.suse.de ([195.135.220.2]:55977 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932781AbXBWXwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:52:22 -0500
Date: Fri, 23 Feb 2007 15:50:13 -0800
From: Greg KH <greg@kroah.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Hancock <hancockr@shaw.ca>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [patch 13/18] V4L: cx88: Fix lockup on suspend
Message-ID: <20070223235013.GA1870@kroah.com>
References: <20070221014413.282048309@mini.kroah.org> <20070221015102.GN3684@kroah.com> <45DCEE6E.80100@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DCEE6E.80100@linuxtv.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 08:14:22PM -0500, Michael Krufky wrote:
> Greg KH wrote:
> > -stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Robert Hancock <hancockr@shaw.ca>
> > 
> > Suspending with the cx88xx module loaded causes the system to lock up
> > because the cx88_audio_thread kthread was missing a try_to_freeze()
> > call, which caused it to go into a tight loop and result in softlockup
> > when suspending. Fix that.
> > 
> > (cherry picked from commit a96afb3e9428f2e7463344f12dbc85faf08e2e09)
> > 
> > Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> 
> Please drop this one... I shouldn't have sent it to 2.6.18.y nor 2.6.19.y ... tree-mixup :-/

Dropped, thanks for letting me know.

greg k-h
