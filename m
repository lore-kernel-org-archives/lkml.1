Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYKXSvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYKXSvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYKXSvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:51:00 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:53220 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbYKXSu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:50:58 -0500
Date: Mon, 24 Nov 2008 19:44:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Nir Tzachar <tzachar@grad120a.cs.bgu.ac.il>, linux-kernel@vger.kernel.org,
       bzolnier@gmail.com, zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       ariveira@gmail.com, rdunlap@xenotime.net,
       kosaki.motohiro@jp.fujitsu.com, 7eggert@gmx.de,
       Nir Tzachar <nir@tzachar.com>
Subject: Re: [PATCH] ncurses based config V2
Message-ID: <20081124184428.GA17085@uranus.ravnborg.org>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com> <1220603220-17090-1-git-send-email-nir@tzachar.com> <20080905195930.GA27913@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905195930.GA27913@1wt.eu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nir.

Some comments as followup to Willy.

> OK, I've just tried it. Here are the first comments I can make :
> 
>   - colors are too dark.
Seconded. Please try to find a lighter set of default colors.
You may be inspired by one of the menuconfig color-sets.

I agree that we could use a lift here - so please do not go for the
default color set of menuconfig.

>   - entering text in boxes (eg: local version) does not move the cursor,
>     it remains at the beginning of the line. If I press any arrow, the
>     box immediately closes (most likely the Esc prefix again).

I do not see any cursor which is annoying. menuconfig has the same issue.

>   - I noticed I was tempted a lot to press "?" to get help, but the key is
>     not bound. It would be nice to have it bound to Help since make oldconfig
>     and menuconfig to both report help that way.

Please bound this.

>   - I'm not convinced that the parenthesis around hotkeys make the menu
>     that much readable, especially when there are lots of short words or
>     even acronyms. Eg :
>         [ ]   (U)TS namespace
>         [ ]   (I)PC namespace
>         [ ]   (U)ser namespace (EXPERIMENTAL)
>         [ ]   (P)ID Namespaces (EXPERIMENTAL)

This looks like some ancient stuff and it must be a better way to
show the short-cuts.

I would really appreciate if you could look into the above issues.
If you do a repost with this fixed I will try to do a proper review,
including code-review next time.

	Sam

