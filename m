Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYEZXQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYEZXQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 19:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYEZXQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 19:16:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:35780 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbYEZXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 19:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ELRThJ2uvUYPp45emwJFuT0YUDPS6bUsNl0SiTLfOyxucVJjSG2EgHY2K+QU9ZVjK0Dn6Lj3OalBGxR8lmEsYlb84q7/LTGgz65WpFV4jxzn3/JNw8zeqZ98FL7WR7CUybawkvG8VzAYDQ2tRpFj2ESv8loAOvYjcYKbU0CxKBc=
Date: Tue, 27 May 2008 03:15:56 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: avorontsov@ru.mvista.com, Gary Jennejohn <garyj@denx.de>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [RFC PATCH 2/2] mmc: add OpenFirmware bindings for the mmc_spi
	driver
Message-ID: <20080526231556.GA7777@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080523182754.GA26891@polina.dev.rtsoft.ru> <fa686aa40805232219x7e888d80y394958f1c0a0fad0@mail.gmail.com> <20080526114914.GA26288@polina.dev.rtsoft.ru> <200805261519.01735.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200805261519.01735.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 03:19:01PM -0700, David Brownell wrote:
> On Monday 26 May 2008, Anton Vorontsov wrote:
> > David, would you [not] suggest us to use platform_data with
> > container_of, that is, are there any plans to make SPI core copy
> > the platform_data instead of passing a pointer directly?
> 
> No such plans.

Ok, great.

> How could it copy, not knowing the size?

Platform bus usually knows the size via platform_device_add_data()...
anyway, we're in safe if there are no plans for this in SPI.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
