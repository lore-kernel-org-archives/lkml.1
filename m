Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbYLFAgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbYLFAgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbYLFAf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:35:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbYLFAf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:35:56 -0500
Date: Fri, 5 Dec 2008 16:26:28 -0800
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@suse.cz>
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
       alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [patch 011/104] fbdev: clean the penguins dirty feet
Message-ID: <20081206002628.GA11240@suse.de>
References: <20081203193901.715896543@mini.kroah.org> <20081203194838.GL8950@kroah.com> <20081205125855.GA1750@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205125855.GA1750@ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 01:58:55PM +0100, Pavel Machek wrote:
> 
> On Wed 2008-12-03 11:48:38, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Clemens Ladisch <clemens@ladisch.de>
> > 
> > commit cf7ee554f3a324e98181b0ea249d9d5be3a0acb8 upstream.
> > 
> > When booting in a direct color mode, the penguin has dirty feet, i.e.,
> > some pixels have the wrong color.  This is caused by
> > fb_set_logo_directpalette() which does not initialize the last 32 palette
> > entries.
> 
> Heh, funny, but... is this really bad enough bug to go to stable?

It was asked to be included, so yes :)

thanks,

greg k-h
