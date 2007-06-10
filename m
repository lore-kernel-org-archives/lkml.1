Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbXFJWOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbXFJWOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 18:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759093AbXFJWN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 18:13:57 -0400
Received: from waste.org ([66.93.16.53]:38675 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102AbXFJWN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 18:13:57 -0400
Date: Sun, 10 Jun 2007 17:13:30 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg KH <gregkh@suse.de>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO translated into Japanese]
Message-ID: <20070610221330.GG11166@waste.org>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de> <20070610175228.GA28947@uranus.ravnborg.org> <Pine.LNX.4.64.0706102034490.25718@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706102034490.25718@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 08:35:03PM +0200, Jan Engelhardt wrote:
> 
> On Jun 10 2007 19:52, Sam Ravnborg wrote:
> >> >  Since the common language of most kernel contributors is english I
> >> >  personally feel that we should stick to just that one language in the
> >> >  tree and then perhaps keep translations on a website somewhere. So the
> >> >  authoritative docs stay in the tree, in english, so that as many
> >> >  contributors as possible can read and update them. It would then be a
> >> >  seperate project to generate translations and keep them updated
> >> >  according to what's in the tree.  Perhaps we could get the kernel.org
> >> >  people to create an official space for that and then place a pointer
> >> >  to that site in Documentation/ somewhere.
> >> 
> >> No, I think the translated files should be in the tree proper, we have
> >> the space :)
> >
> >We once discussed about .po files for kconfig and back then
> >the conclusion was not to keep them in the kernel tree.
> >
> >I advocated that they should stay out back then.
> >But on the other hand I do not see it causing much troubles
> >having scripts/kconfig/po/da.po etc araound.
> >
> >Any opinion about the .po files?
> 
> Like with translated doc, they might get out of date easily.

Well, if for each document you translate, you record what revision you
translated (git hash or kernel release), it's fairly easy to generate
diffs and know what changes need to be translated.

I don't think keeping the translations of Documentation/ in the kernel
tree eases this significantly though.

-- 
Mathematics is the supreme nostalgia of our time.
