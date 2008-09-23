Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbYIWWRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbYIWWRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYIWWRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:17:15 -0400
Received: from spamtitan.hbci.com ([206.230.105.6]:56079 "EHLO
	spamtitan.hbci.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYIWWRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:17:14 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2008 18:17:14 EDT
Date: Tue, 23 Sep 2008 16:47:29 -0500
From: Lance Tagliapietra <lancetag@Luminet.net>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Adrian Bunk <bunk@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] m68k: Reverse platform MMU logic so Sun 3 is last
Message-ID: <20080923214728.GH25462@luminet.net>
Reply-To: lancetag@Luminet.net
References: <20080903071542.615137611@mail.of.borg> <20080903071741.424551678@mail.of.borg> <20080903073629.GD4104@cs181140183.pp.htv.fi> <1220440421.4159.22.camel@frecb07144>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220440421.4159.22.camel@frecb07144>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 01:13:41PM +0200, Laurent Vivier wrote:
> Le mercredi 03 septembre 2008 ?? 10:36 +0300, Adrian Bunk a ??crit :
> > On Wed, Sep 03, 2008 at 09:15:44AM +0200, Geert Uytterhoeven wrote:
> > > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > > 
> > > Currently Sun 3 support is the first platform option, as the Sun 3 MMU is
> > > incompatible with standard Motorola MMUs. However, this means that
> > > `allmodconfig' enables support for Sun 3, and thus disables support for all
> > > other platforms.
> > >...
> > 
> > I hope it isn't too heretical to ask whether Sun 3 support actually has 
> > users and works?
> > 
> > Apollo support was broken for over 7 years without anyone noticing, and 
> > it might not be the only m68k platform that is long unused.
> > 
> > Do you have any overview of which m68k platforms still have users?
> 
> At least 4 users for amiga and 2 for mac :-P
> 
> #rank name                            inst  vote   old recent no-files
> 42014 linux-image-2.6-amiga              4     0     0     0     4
> 53844 linux-image-2.6-mac                2     0     0     0     2
> 
> from http://popcon.debian.org/by_inst
> 
> I'm a mac m68k user (who is the other one ???)
> 
> Laurent
> -- 
> ----------------- Laurent.Vivier@bull.net  ------------------
>   "La perfection est atteinte non quand il ne reste rien ??
> ajouter mais quand il ne reste rien ?? enlever." Saint Exup??ry
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

OK OK, looks like I have to do the upgrade to 2.6 to get on this list
(currently running a self-compiled 2.4.30, with just the drivers I need
to have the smallest kernel footprint for the 16M RAM on my A2000) but I
do run popularity contest, so the common m68k packages that I use daily
should show up (mutt, apache, etc).  

Also, I have found that NFS works nicely between my A2000 and my PC
linux box, thought you typically don't want to burn the RAM on the 8
processes it is going to default to.  Apache, there are some ways to get
it to not use up all the RAM resources of the system too.  If anyone is
interested, I could put together a list of apps that I have configured
to make the Amiga still be a useful box?

--Lance
