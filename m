Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbYLFCtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbYLFCtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYLFCtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:49:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907AbYLFCtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:49:05 -0500
Date: Fri, 5 Dec 2008 18:44:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [patch 011/104] fbdev: clean the penguins dirty feet
Message-Id: <20081205184452.b3155408.akpm@linux-foundation.org>
In-Reply-To: <20081205125855.GA1750@ucw.cz>
References: <20081203193901.715896543@mini.kroah.org>
	<20081203194838.GL8950@kroah.com>
	<20081205125855.GA1750@ucw.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008 13:58:55 +0100 Pavel Machek <pavel@suse.cz> wrote:

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

Borderline.  But the patch was pretty simple.

Also, there's the question "is this the sort of bug which distro
customers are likely to report to the distros".  I figure "yes", and I
figure that the distros would like us to fix it for them.  Of course,
I might be wrong about one or both of those things ;)
