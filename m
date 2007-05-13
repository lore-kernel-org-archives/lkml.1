Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbXEMGLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbXEMGLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbXEMGLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:11:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758100AbXEMGLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:11:04 -0400
Date: Sat, 12 May 2007 23:03:40 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Maciej W. Rozycki" <macro-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>,
       kernel-discuss-CN5wO63fgwogsBAKwltoeQ@public.gmane.org,
       linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbou-JGs/UdohzUI@public.gmane.org>, zaitcev@redhat.com
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-Id: <20070512230340.fef4b791.zaitcev@redhat.com>
In-Reply-To: <1179034789.2802.61.camel@shinybook.infradead.org>
References: <20070503213303.GH20067@zarina>
	<20070507140453.GD3868@ucw.cz>
	<1178550653.11851.191.camel@pmac.infradead.org>
	<20070507194949.GB3981@ucw.cz>
	<a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com>
	<Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl>
	<1178646751.2824.48.camel@pmac.infradead.org>
	<20070512093509.f3d1865f.zaitcev@redhat.com>
	<1179034789.2802.61.camel@shinybook.infradead.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 13:39:48 +0800, David Woodhouse <dwmw2@infradead.org> wrote:

> Please don't use my work email address unless I _really_ need to be
> wearing my tinfoil hat when I read it.

I'll keep it in mind, sorry.

> But we'd be wrong -- just as you are. SPF is utterly moronic because it
> suddenly tries to change the rules and assumes that everyone has already
> changed, or it throws away valid email from unknown senders. In the case
> of sending patches, yes you _do_ assume that people aren't doing bizarre
> things to mangle them in transit, but that mangling is actually
> relatively rare. Not only that, but you only really care about a
> _single_ transit path, from you to whoever applies the patch. Which is
> easy enough to debug if it starts to do stupid things like converting to
> HTML or converting charsets.

I see your point, and it makes sense, but I'm not sure I agree completely.
Maybe I'm traumatized by myterious rejects which happened to me before.
Looking at the patch with vi showed absolutely no clue why it failed.

BTW, here's one odd thing Gmane is doing:

> + * Battery driver for One Laptop Per Child ($100 laptop) board.
> + *
> + *	Copyright б╘ 2006  David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

The above is how I saw the Anton Vorontsov's message. The e-mail would
be corrupted no matter the charset, so that is bad. But what about the
copyright character? It's not Gmane's doing. The reason that not working
is this:

> From: Anton Vorontsov <cbou-JGs/UdohzUI@public.gmane.org>
> Content-Type: text/plain; charset=koi8-r
> Content-Transfer-Encoding: quoted-printable

Anton took the UTF-8 text and sent it with wrong encoding. Such mismatch is
the most common problem in my experience, not conversions to HTML.

-- Pete
