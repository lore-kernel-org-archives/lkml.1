Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYKQXpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYKQXpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYKQXpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:45:43 -0500
Received: from anguilla.debian.or.at ([86.59.21.37]:45440 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYKQXpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:45:40 -0500
Date: Tue, 18 Nov 2008 00:45:39 +0100
From: Peter Palfrader <peter@palfrader.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [stable] [patch 24/46] Fix broken ownership of /proc/sys/ files
Message-ID: <20081117234539.GL8151@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	linux-kernel@vger.kernel.org
References: <20081117070621.430169021@blue.kroah.org> <20081117200859.GF14523@mit.edu> <20081117213558.GA9808@kroah.com> <200811172325.11828.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200811172325.11828.rjw@sisk.pl>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, Rafael J. Wysocki wrote:

> On Monday, 17 of November 2008, Greg KH wrote:
> > On Mon, Nov 17, 2008 at 03:09:00PM -0500, Theodore Tso wrote:
> > > On Sun, Nov 16, 2008 at 11:15:47PM -0800, Greg KH wrote:
> > > > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > > > ------------------
> > > > 
> > > > From: Al Viro <viro@ZenIV.linux.org.uk>
> > > > 
> > > > commit 5c06fe772da43db63b053addcd2c267f76d0be91 upstream.
> > > > 
> > > > D'oh...
> > > > 
> > > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > > Reported-and-tested-by: Peter Palfrader <peter@palfrader.org>
> > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > It's harmless to include this, but I thought this fixed a regression
> > > that showed up only after 2.6.28-rc4?
> > 
> > I thought I saw a report that it happened for someone using the 2.6.27.y
> > tree as well.
> 
> Yes, 2.6.27(.y) was referred to in the original report.

Yup.  The earliest 2.6.27 I have running anywhere is 2.6.27-rc4 and that
is affected already, as are all the various 2.6.27.y.

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
