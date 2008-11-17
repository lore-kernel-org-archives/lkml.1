Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbYKQUQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbYKQUQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYKQUQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:16:27 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58399 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbYKQUQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:16:26 -0500
Date: Mon, 17 Nov 2008 15:09:00 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 24/46] Fix broken ownership of /proc/sys/ files
Message-ID: <20081117200859.GF14523@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
References: <20081117070621.430169021@blue.kroah.org> <20081117071547.GY29522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117071547.GY29522@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 11:15:47PM -0800, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> ------------------
> 
> From: Al Viro <viro@ZenIV.linux.org.uk>
> 
> commit 5c06fe772da43db63b053addcd2c267f76d0be91 upstream.
> 
> D'oh...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Reported-and-tested-by: Peter Palfrader <peter@palfrader.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

It's harmless to include this, but I thought this fixed a regression
that showed up only after 2.6.28-rc4?

						- Ted
