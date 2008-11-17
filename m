Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYKQWUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYKQWUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbYKQWUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:20:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48512 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbYKQWUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:20:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [patch 24/46] Fix broken ownership of /proc/sys/ files
Date: Mon, 17 Nov 2008 23:25:09 +0100
User-Agent: KMail/1.9.9
Cc: Theodore Tso <tytso@mit.edu>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
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
References: <20081117070621.430169021@blue.kroah.org> <20081117200859.GF14523@mit.edu> <20081117213558.GA9808@kroah.com>
In-Reply-To: <20081117213558.GA9808@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811172325.11828.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 17 of November 2008, Greg KH wrote:
> On Mon, Nov 17, 2008 at 03:09:00PM -0500, Theodore Tso wrote:
> > On Sun, Nov 16, 2008 at 11:15:47PM -0800, Greg KH wrote:
> > > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > > ------------------
> > > 
> > > From: Al Viro <viro@ZenIV.linux.org.uk>
> > > 
> > > commit 5c06fe772da43db63b053addcd2c267f76d0be91 upstream.
> > > 
> > > D'oh...
> > > 
> > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > Reported-and-tested-by: Peter Palfrader <peter@palfrader.org>
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > It's harmless to include this, but I thought this fixed a regression
> > that showed up only after 2.6.28-rc4?
> 
> I thought I saw a report that it happened for someone using the 2.6.27.y
> tree as well.

Yes, 2.6.27(.y) was referred to in the original report.

Thanks,
Rafael
