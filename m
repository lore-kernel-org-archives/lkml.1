Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbYEXGlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbYEXGlc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 02:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbYEXGlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 02:41:22 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56915 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784AbYEXGlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 02:41:22 -0400
Date: Sat, 24 May 2008 08:42:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steve French <smfrench@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Message-ID: <20080524064201.GA4133@uranus.ravnborg.org>
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4837AAE2.9090102@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 10:42:58PM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >>*However*, the best would really be if we changed Kconfig to emit 
> >>configuration constants what were 0/1 instead of undefined/defined. 
> >>That way we could do:
> >>
> >>	if (CONFIG_SOMETHING && foo) {
> >>		/* ... something ... */
> >>	} else if ((mode & S_IWUGO) == 0) {
> >>		/* ... */
> >
> >We could do that - but then it would need another
> >name not to clash with all the places where we rely
> >on CONFIG_FOO='n' => CONFIG_FOO is not defined.
> >
> >We could teach kconfig to emit something like:
> >#define KFOO 0   (for the 'n' value)
> >And 1 or 2 for the y and m values.
> >
> 
> I don't think we want to use "1 or 2"... I suspect we want to use the 
> same booleans we currently have.
I'm a bit dense (or I need more coffe - it's morning here).
What "same booleans"?

> I would suggest CFG_* instead of CONFIG_* for the new set.
Agreed.

	Sam
