Return-Path: <linux-kernel-owner+w=401wt.eu-S1764972AbXESWSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764972AbXESWSF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757178AbXESWR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:17:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:18138 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbXESWRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eQXSmDIzapCFV+xxib9O1YIhHblidOIzOYtqLxhhZUczdb+hz2myb6V1v+LPkfoUbCr6HPfIpD6gu2SMb4qc8ZVfHGNGdNbb8rYXR4wsMllvDHeEuAJSL0pas6qDc+ejANa7aWAAnl71liV8538DGq5+hQ93uTBWko2wT0euVvw=
Message-ID: <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>
Date: Sun, 20 May 2007 03:47:51 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>
In-Reply-To: <20070519110944.2a52061e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <20070519110944.2a52061e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 19 May 2007 17:15:23 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> > We see a lot of these lately:
> >   GEN     /home/bor/build/linux-2.6.22/Makefile
> > scripts/kconfig/conf -s arch/i386/Kconfig
> > drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol 'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
> > drivers/net/Kconfig:2283:warning: 'select' used by config symbol 'UCC_GETH' refers to undefined symbol 'UCC_FAST'
> > drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> > drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> >
> >
> > Do this warning really add any value or should we just ignore them like this?
> >
>
> They always indicate Kconfig bugs, don't they?  If so, we should keep the
> warning.
>
> We should also fix the Kconfig bugs but for some reason they tend to hang
> around for ages and ages.

I remember coming across a thread couple weeks back that contained
patches that eliminated all four of these .. perhaps nobody picked them
up. Adding the authors of those patches to CC list (those that I
remember, at least).

(later)

I think this is the thread, in any case:

http://groups.google.com/group/linux.kernel/browse_frm/thread/d46d5dcecb84424a/1b586d67a1205d86?tvc=1
