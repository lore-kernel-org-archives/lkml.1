Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZAUSBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZAUSBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbZAUSBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:01:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZAUSBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:01:04 -0500
Message-ID: <49776208.8050704@kernel.org>
Date: Wed, 21 Jan 2009 09:57:28 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Arnd Bergmann <arnd@arndb.de>, Helge Deller <deller@gmx.de>,
       David Miller <davem@davemloft.net>, jaswinder@kernel.org, mingo@elte.hu,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
References: <1232496257.3123.19.camel@localhost.localdomain> <200901210924.23484.arnd@arndb.de> <20090121113853.GB1579@uranus.ravnborg.org> <200901211313.17394.arnd@arndb.de> <20090121172837.GA4386@uranus.ravnborg.org>
In-Reply-To: <20090121172837.GA4386@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> It gives the warning only if you add -Wundef which IIRC is not default
> with -Wall. And using the "__BITS_PER_LONG == 64" the risk of gitting
> the expression wrong is much higher than the simpler variant where
> you only write:
> 
>     __64BIT
> 
> But I have no strong feelings for it.
> 

It's not the default, but it would be nice if we could start using it.

	-hpa
