Return-Path: <linux-kernel-owner+w=401wt.eu-S1765812AbZAQVib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765812AbZAQVib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZAQViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:38:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:36765 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZAQViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:38:08 -0500
Subject: Re: [GIT PULL -tip] fix 33 make headers_check warnings
From: David Woodhouse <dwmw2@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       urs.thuermann@volkswagen.de, oliver.hartkopp@volkswagen.de,
       linux-media@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, bfields@fieldses.org, neilb@suse.de,
       linux-nfs@vger.kernel.org, linux-raid@vger.kernel.org,
       dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, netdev@vger.kernel.org,
       greg@kroah.com, linux-usb@vger.kernel.org,
       linux-mtd@lists.infradead.org, tiwai@suse.de, mchehab@infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1232223441.3966.22.camel@localhost.localdomain>
References: <1232223441.3966.22.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 08:37:41 +1100
Message-Id: <1232228261.27094.0.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 01:47 +0530, Jaswinder Singh Rajput wrote:
> --- a/include/linux/dvb/audio.h
> +++ b/include/linux/dvb/audio.h
> @@ -24,9 +24,8 @@
>  #ifndef _DVBAUDIO_H_
>  #define _DVBAUDIO_H_
>  
> -#ifdef __KERNEL__
>  #include <linux/types.h>
> -#else
> +#ifndef __KERNEL__
>  #include <stdint.h>
>  #endif
>  

That patch looks wrong, and unnecessary. It was fine before.

-- 
dwmw2

