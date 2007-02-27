Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbXB0TjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbXB0TjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933081AbXB0TjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:39:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:12667 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083AbXB0TjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:39:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fYqBwstgchx3m4hUG3c1flwWPg9SO4LY8Ku7t8pIX6oQLWwmvUNIikGk79IHXaZ3xy2218NUsMcqo2MyE9osAoBkQHoMlwdS3WbwJdVQHtn6dqXb7gRAeRO09sR6P2+FfuAhpkOYeQyyVsAki/iXG8oJIo5D9Bs3LjP6S37D/Pg=
Date: Tue, 27 Feb 2007 22:39:18 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Kyle McMartin <kyle@parisc-linux.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: resource_size_t printk whinging
Message-ID: <20070227193918.GA5594@martell.zuzino.mipt.ru>
References: <20070227041648.GB13669@athena.road.mcmartin.ca> <Pine.LNX.4.62.0702271201330.21803@pademelon.sonytel.be> <20070227131506.GA3545@athena.road.mcmartin.ca> <45E44914.4010407@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E44914.4010407@imap.cc>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 04:07:00PM +0100, Tilman Schmidt wrote:
> Kyle McMartin schrieb:
> > On Tue, Feb 27, 2007 at 12:02:50PM +0100, Geert Uytterhoeven wrote:
> >> But we don't run sparse on every build. We do run gcc (a lot).
> > 
> > We probably could, in theory...
> 
> Not usefully. I try it occasionally, but there's way too much spewage,
> in particular of the "symbol was not declared. Should it be static?"
> and "symbol shadows an earlier one" varieties.

	make C=2 CF="-Wno-decl -Wno-shadow [-Wno-context]"

