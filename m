Return-Path: <linux-kernel-owner+w=401wt.eu-S933773AbXCTEHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbXCTEHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 00:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933972AbXCTEHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 00:07:30 -0400
Received: from mx1.suse.de ([195.135.220.2]:48362 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933773AbXCTEH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 00:07:29 -0400
Date: Mon, 19 Mar 2007 21:05:07 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 03/31] Fix user copy length in ipv6_sockglue.c
Message-ID: <20070320040507.GA17101@kroah.com>
References: <20070319213047.710101653@mini.kroah.org> <20070319213729.GE9261@kroah.com> <20070319220125.GD10574@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319220125.GD10574@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 03:01:25PM -0700, Chris Wright wrote:
> * Greg KH (gregkh@suse.de) wrote:
> > From: Chris Wright <chrisw@sous-sol.org>
> > 
> > [IPV6] fix ipv6_getsockopt_sticky copy_to_user leak
> > 
> > User supplied len < 0 can cause leak of kernel memory.
> > Use unsigned compare instead.
> 
> You can drop this one.  It's dependent on a patch
> that is not in 2.6.20.

Ok, thanks for letting me know, it is now dropped.

greg k-h
