Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZGKEnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZGKEnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 00:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZGKEnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 00:43:22 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:58348 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZGKEnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 00:43:22 -0400
Date: Sat, 11 Jul 2009 00:41:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Andrew Price <andy@andrewprice.me.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: once again, what's with "drivers/char/vr41xx_giu.c"?
In-Reply-To: <20090711013212.GA1252@sucs.org>
Message-ID: <alpine.LFD.2.00.0907110038560.25337@localhost>
References: <alpine.LFD.2.00.0907100505400.11274@localhost> <20090711013212.GA1252@sucs.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009, Andrew Price wrote:

> Hi Robert,
>
> On Fri, Jul 10, 2009 at 05:06:49AM -0400, Robert P. J. Day wrote:
> >
> >   on an occasional basis (after pulls), i get:
> >
> > $ git diff
> > diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
> > deleted file mode 100644
> > index e69de29..0000000
> > $
> >
> > not the first time i've seen that, either.  methinks that file got
> > itself into a funny state.
>
> No need to panic, ...

i never panic -- i always know where my towel is.

> it just looks like somebody left an empty file without 'git rm'ing
> it. When you run 'make distclean' for example, it removes all empty
> files and leaves you with an unclean checkout. You can get the
> (empty) file back by 'git checkout'ing the file. But yes, you
> shouldn't have to. Anyway, CCing Linus to bring it to his attention.

  i knew it was something like that as i recall whining about
*exactly* this happening many months ago with a different file, i just
couldn't remember the cause.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
"Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
========================================================================
