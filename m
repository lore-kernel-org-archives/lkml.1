Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbXH3WUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbXH3WUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762337AbXH3WUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:20:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1220 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762005AbXH3WT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:19:59 -0400
Subject: Re: [PATCH 13/30] net: Don't do pointless kmalloc return value
	casts in zd1211 driver
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Daniel Drake <dsd@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Ulrich Kunitz <kune@deine-taler.de>, linux-wireless@vger.kernel.org
In-Reply-To: <9a8748490708301320o49d8e794vc5c37ffc938006f1@mail.gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <d551047daed1cb4d9de1eff956268a468c9837f6.1187912217.git.jesper.juhl@gmail.com>
	 <46D70467.1040109@gentoo.org>
	 <9a8748490708301320o49d8e794vc5c37ffc938006f1@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 15:19:53 -0700
Message-Id: <1188512393.6062.156.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 22:20 +0200, Jesper Juhl wrote:
> Ok, I must admit I didn't check with sparse since it seemed pointless
> - we usually never cast void pointers to other pointer types,
> specifically because the C language nicely guarantees that the right
> thing will happen without the cast.  Sometimes we have to cast them to
> integer types, su sure we need the cast there.   But what on earth
> makes a "zd_addr_t *" so special that we have to explicitly cast a
> "void *" to that type?

http://marc.info/?l=linux-netdev&m=117113743902549&w=1

