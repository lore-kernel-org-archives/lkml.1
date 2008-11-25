Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYKYCeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYKYCeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 21:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYKYCe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 21:34:28 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2034 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYKYCe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 21:34:28 -0500
Date: Tue, 25 Nov 2008 03:33:46 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-kbuild@vger.kernel.org, ariveira@gmail.com, rdunlap@xenotime.net,
       kosaki.motohiro@jp.fujitsu.com, 7eggert@gmx.de,
       Nir Tzachar <nir@tzachar.com>
Subject: Re: [PATCH] ncurses based config V2
In-Reply-To: <20081124184428.GA17085@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0811250333060.13549@localhost.localdomain>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com>
 <1220603220-17090-1-git-send-email-nir@tzachar.com> <20080905195930.GA27913@1wt.eu>
 <20081124184428.GA17085@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 24 Nov 2008, Sam Ravnborg wrote:

> >   - colors are too dark.
> Seconded. Please try to find a lighter set of default colors.
> You may be inspired by one of the menuconfig color-sets.
> 
> I agree that we could use a lift here - so please do not go for the
> default color set of menuconfig.

Well, the current colors seems to usable on wide variety of terminals, but 
I'm not colorblind, so I can't really complain. :)
Before we keep discussing the colors, I'd rather suggest to drop them 
completely and maybe use colors for what actually needs attention.

> >   - I'm not convinced that the parenthesis around hotkeys make the menu
> >     that much readable, especially when there are lots of short words or
> >     even acronyms. Eg :
> >         [ ]   (U)TS namespace
> >         [ ]   (I)PC namespace
> >         [ ]   (U)ser namespace (EXPERIMENTAL)
> >         [ ]   (P)ID Namespaces (EXPERIMENTAL)
> 
> This looks like some ancient stuff and it must be a better way to
> show the short-cuts.

The parenthesis make it really annoying to read...

> I would really appreciate if you could look into the above issues.
> If you do a repost with this fixed I will try to do a proper review,
> including code-review next time.

The code is rather large, so it might be better to split the code into two 
sources, one for kconfig logic and the other for the interface logic, so 
it becomes easier to read and maintain.

bye, Roman
