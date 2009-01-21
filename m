Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbZAUQsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbZAUQsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 11:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZAUQsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 11:48:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZAUQsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 11:48:40 -0500
Message-ID: <49775108.7040200@kernel.org>
Date: Wed, 21 Jan 2009 08:44:56 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sam Ravnborg <sam@ravnborg.org>, Helge Deller <deller@gmx.de>,
       David Miller <davem@davemloft.net>, jaswinder@kernel.org, mingo@elte.hu,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
References: <1232496257.3123.19.camel@localhost.localdomain> <200901210924.23484.arnd@arndb.de> <20090121113853.GB1579@uranus.ravnborg.org> <200901211313.17394.arnd@arndb.de>
In-Reply-To: <200901211313.17394.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> I would prefer using the __BITS_PER_LONG == 64 check directly, because
> it gives you a warning when __BITS_PER_LONG is undefined, whereas the
> #ifdef check gets easily fooled by include order problems. Note that
> this is not a problem in the kernel for CONFIG_* symbols which are
> always defined before the first #include.
> 

I fully agree with this.  It actually *is* a problem for CONFIG_*
symbols too, since people typo them all the time.

	-hpa
