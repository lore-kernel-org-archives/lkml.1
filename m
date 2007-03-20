Return-Path: <linux-kernel-owner+w=401wt.eu-S933972AbXCTEU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972AbXCTEU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 00:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933974AbXCTEU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 00:20:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:51285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933972AbXCTEU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 00:20:26 -0400
Date: Mon, 19 Mar 2007 21:18:29 -0700
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, torvalds@linux-foundation.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 29/31] Input: i8042 - fix AUX IRQ delivery check
Message-ID: <20070320041829.GB17101@kroah.com>
References: <20070319213047.710101653@mini.kroah.org> <20070319213647.GB9261@kroah.com> <20070319214108.GE9261@kroah.com> <d120d5000703191448m67c1afcnc3340c956ef7a25a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000703191448m67c1afcnc3340c956ef7a25a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 05:48:55PM -0400, Dmitry Torokhov wrote:
> On 3/19/07, Greg KH <gregkh@suse.de> wrote:
> > -stable review patch.  If anyone has any objections, please let us know.
> >
> > ------------------
> >
> > From: Dmitry Torokhov <dtor@insightbb.com>
> >
> > Input: i8042 - fix AUX IRQ delivery check
> >
> > On boxes that do not implement AUX LOOP command we can not
> > verify AUX IRQ delivery and must assume that it is wired
> > properly.
> >
> 
> Greg,
> 
> There is another piece missing in AUX delivery test, commit
> 
>     3ca5de6dd4ec5a139b2b8f00dce3e4726ca91af1
> 
> Unfortunately I can't send you a patch at the moment but if you could
> get it from the mainline that would be great.

Thanks for letting me know, I've added it to the queue now.

greg k-h
