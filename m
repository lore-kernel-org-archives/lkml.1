Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbXJaJo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbXJaJo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbXJaJov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:44:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36741 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbXJaJov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:44:51 -0400
Date: Wed, 31 Oct 2007 10:46:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: raa.lkml@gmail.com, linux-kernel@vger.kernel.org, per.liden@ericsson.com,
       allan.stephens@windriver.com
Subject: Re: tipc_config.h requires linux/string.h, which does not exist in exported headers
Message-ID: <20071031094626.GC24100@uranus.ravnborg.org>
References: <20071030222025.GA19792@uranus.ravnborg.org> <20071030.153154.241148799.davem@davemloft.net> <20071030.211404.43558275.davem@davemloft.net> <20071030.215616.241765510.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030.215616.241765510.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Here is what I mean, specifically.  And this is build tested :-)
> 
> From 97ef1bb0c8e371b7988287f38bd107c4aa14d78d Mon Sep 17 00:00:00 2001
> From: David S. Miller <davem@sunset.davemloft.net>
> Date: Tue, 30 Oct 2007 21:44:00 -0700
> Subject: [PATCH] [TIPC]: Fix headercheck wrt. tipc_config.h
> 
> It wants string functions like memcpy() for inline
> routines, and these define userland interfaces.
> 
> The only clean way to deal with this is to simply
> put linux/string.h into unifdef-y and have it
> include <string.h> when not-__KERNEL__.

Hi David.

Thanks for fixing this.
I will close the bug when the correcting hit mainline.

	Sam
