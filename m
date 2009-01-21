Return-Path: <linux-kernel-owner+w=401wt.eu-S1763293AbZAUBGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763293AbZAUBGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 20:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbZAUBGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 20:06:22 -0500
Received: from khc.piap.pl ([195.187.100.11]:52536 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757738AbZAUBGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 20:06:22 -0500
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, netdev@vger.kernel.org,
       davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: why usr/include/linux/if_frad.h is required
References: <1232463174.3088.15.camel@localhost.localdomain>
	<1232463242.3088.16.camel@localhost.localdomain>
	<200901201847.03030.arnd@arndb.de>
	<m3zlhlycso.fsf@intrepid.localdomain>
	<1232495335.3123.13.camel@localhost.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 21 Jan 2009 02:06:18 +0100
In-Reply-To: <1232495335.3123.13.camel@localhost.localdomain> (Jaswinder Singh Rajput's message of "Wed\, 21 Jan 2009 05\:18\:55 +0530")
Message-ID: <m3bpu1xyb9.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> writes:

> usr/include/linux/if_frad.h is covered with CONFIG_DLCI from many years
> and no body is complaining about it so it means no body is using it.
>
> So should we need to drop #if / #endif pair or the whole file from
> userspace.

I think the file. "Empty file exported to userspace", long unused. We
can also have it back there, and it being not exported is an indicator
that it's not used. I guess the #ifdef __KERNEL__ can be removed, too.
-- 
Krzysztof Halasa
