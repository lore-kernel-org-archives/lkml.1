Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbZERXiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbZERXiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 19:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZERXiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 19:38:15 -0400
Received: from kroah.org ([198.145.64.141]:39514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZERXiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 19:38:15 -0400
Date: Mon, 18 May 2009 16:33:16 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "John W. Linville" <linville@tuxdriver.com>,
       torvalds@linux-foundation.org, Eugene Teo <eteo@redhat.com>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Jake Edge <jake@lwn.net>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 29/51] mac80211: pid, fix memory corruption
Message-ID: <20090518233316.GA8754@kroah.com>
References: <20090514223235.348540705@mini.kroah.org> <20090514223525.042094922@mini.kroah.org> <4A0D0A76.7040806@gmail.com> <20090515144901.GB27812@suse.de> <4A0D85A3.1030806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0D85A3.1030806@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 05:09:23PM +0200, Jiri Slaby wrote:
> On 05/15/2009 04:49 PM, Greg KH wrote:
> > On Fri, May 15, 2009 at 08:23:50AM +0200, Jiri Slaby wrote:
> >> Hi,
> >>
> >> note that you were about to drop this one now because of waiting for a
> >> fixup which is not upstream so far. Did anything change?
> > 
> > Hm, no, I dropped a different patch,
> > 	mac80211-minstrel-fix-memory-corruption.patch
> > did I drop the wrong one?
> > 
> > 
> > Should I bring that one back and drop the one below?
> > 
> > confused,
> 
> Ah, sorry for the confusion, I didn't realize there are 2 of them. Both
> suffer from the same, because it's a cut&paste code.
> 
> Please drop this one too.

Ok, I've dropped it too, and will pick up all 3 for the next .29-stable
release.

thanks,

greg k-h
