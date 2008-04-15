Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbYDOILO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbYDOILO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYDOIK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:10:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:5218 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbYDOIKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UmSXhUJn2l3SeFtCiSvb+tg4vDw3l9othKt3cIi/FOtPxysrZ6d//hzGIx47K4bbpW0xdILsUjr7HSA1iZ3caDFASlmgVO+Crd9+PA4yoFz4aEmy/qDmzzdDoVyWd/5mT0Tu6wvPHZ+uCvaY3+J1gXwkerqt0gh/N7AdV1iUN3M=
Message-ID: <544ab8580804150110x2f1841b4m7ebd43f1a6441458@mail.gmail.com>
Date: Tue, 15 Apr 2008 10:10:53 +0200
From: "=?ISO-8859-1?Q?K=E1roly_Kasza?=" <kaszak@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: w35und: add softmac interface
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "kernel list" <linux-kernel@vger.kernel.org>, lcostantino@gmail.com,
       someone@dunanet.hu
In-Reply-To: <20080415070923.GA13767@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080414224740.GA31431@elf.ucw.cz>
	 <20080415002826.GC4270@tuxdriver.com>
	 <20080415070923.GA13767@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 9:22 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>  > > This adds softmac interface to w35und driver... so it becomes monster
>  > > driver with _two_ interfaces.
>  > >
>  > > If you initialize hardmac interface, then softmac starts to
>  > > works... it associates to AP, and can even ping.
>  > >
>  > > (Or at least I hope so... it was somewhat too easy.)
>  >
>
> > OK, I'm late to the party...what is this stuff going into
>  > drivers/net/wireless?
>
>  Actually you are about month early to the party ;-). We are trying to
>  clean up winbond usb wireless driver, so that it can think about
>  inclusion in kernel.
>
>  http://code.google.com/p/winbondport/
>
>  Unfortunately, original driver carries its own 802.11 stack with it;
>  that needs to be stripped down. (And then code needs to be rewritten
>  due to horrible coding style).
>                                                                 Pavel
>

Hi!

Last weekend we have started to rewrite the whole code based on
rtl8187's softmac driver.
The wlan0 device init with it's own mac is ok, but thats all so far. I
think it would be more sane to just drop the
old driver now (it would take more work the correct the old one), and
create a new svn branch for the softmac
only brand new one.

KK
