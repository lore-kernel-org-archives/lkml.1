Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYKBRaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYKBRaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 12:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYKBRan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 12:30:43 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:43330 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYKBRam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 12:30:42 -0500
Date: Sat, 1 Nov 2008 22:17:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Al Viro <viro@ftp.linux.org.uk>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] el3_common_init() should be __devinit, not __init
Message-ID: <20081101211724.GA16941@uranus.ravnborg.org>
References: <E1KwL59-0000Ug-F1@ZenIV.linux.org.uk> <20081101191250.GA7588@x200.localdomain> <20081101191614.GA28946@ZenIV.linux.org.uk> <20081101192757.GA7622@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081101192757.GA7622@x200.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2008 at 10:27:57PM +0300, Alexey Dobriyan wrote:
> On Sat, Nov 01, 2008 at 07:16:14PM +0000, Al Viro wrote:
> > On Sat, Nov 01, 2008 at 10:12:50PM +0300, Alexey Dobriyan wrote:
> > > On Sat, Nov 01, 2008 at 06:20:19PM +0000, Al Viro wrote:
> > > > -static int __init el3_common_init(struct net_device *dev)
> > > > +static int __devinit el3_common_init(struct net_device *dev)
> > > 
> > > Al, here is much better patch:
> > 
> > [essentially kill devinit/cpuinit]
> > 
> > What the hell makes it better?
> 
> Wasting efforts for too little gain?

And what is the wasted gain - numbers please.
And please come up with relevant numbers for a number of
embedded configs. The normal desktop/server usage does not count here.

For cpuinit/cpuexit the gain turned out to be minimal.
But I have so far seen _zero_ numbers on the real gain for
devinit/devexit and meminit/memexit.

	Sam
