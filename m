Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbZEOOxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbZEOOxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbZEOOxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:53:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbZEOOxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:53:31 -0400
Date: Fri, 15 May 2009 07:49:01 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch 29/51] mac80211: pid, fix memory corruption
Message-ID: <20090515144901.GB27812@suse.de>
References: <20090514223235.348540705@mini.kroah.org> <20090514223525.042094922@mini.kroah.org> <4A0D0A76.7040806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0D0A76.7040806@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 08:23:50AM +0200, Jiri Slaby wrote:
> Hi,
> 
> note that you were about to drop this one now because of waiting for a
> fixup which is not upstream so far. Did anything change?

Hm, no, I dropped a different patch,
	mac80211-minstrel-fix-memory-corruption.patch
did I drop the wrong one?


Should I bring that one back and drop the one below?

confused,

greg k-h

> (This is the one which fixes a memory corruption, but triggers a bug
> causing oopses on single band cards.)
> 
> On 05/15/2009 12:33 AM, Greg KH wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> 
> commit 6909268dc93ae4b0b8e1ebb4b2fa70b1a47dd347 upstream.
> 
> pid doesn't count with some band having more bitrates than the one
> associated the first time.
> Fix that by counting the maximal available bitrate count and allocate
> big enough space.
> 
> Secondly, fix touching uninitialized memory which causes panics.
> Index sucked from this random memory points to the hell.
> The fix is to sort the rates on each band change.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
