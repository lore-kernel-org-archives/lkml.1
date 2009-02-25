Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbZBYOgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbZBYOgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbZBYOgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:36:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:34965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345AbZBYOgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:36:36 -0500
Message-ID: <49A55771.1050408@suse.de>
Date: Wed, 25 Feb 2009 15:36:33 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-crypto@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
       akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
       nhorman@tuxdriver.com, lho@amcc.com, kaber@trash.net,
       darrenrjenkins@gmail.com, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
References: <49A54C23.8090209@suse.de> <20090225142000.GA4136@gondor.apana.org.au> <49A55499.6090700@suse.de> <20090225142744.GA4331@gondor.apana.org.au> <alpine.LRH.2.00.0902251529440.15476@vixen.sonytel.be>
In-Reply-To: <alpine.LRH.2.00.0902251529440.15476@vixen.sonytel.be>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> Probably people should be reminded tcrypt can only be a module, not built-in,
> so it won't waste precious unswappable kernel memory if it's static.

Thats right, but it also doesn't hurt to simply use kmalloc, does it? :-)
I just stumbled over tcrypt on the make checkstack output and as also
the kerneljanitors todo advises to reduce this footprint where possible
i just wanted to help out here.

Thanks,
Frank
