Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYFWDPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYFWDPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYFWDP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:15:28 -0400
Received: from ozlabs.org ([203.10.76.45]:40086 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYFWDP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:15:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] module: reorder struct module to save space on 64 bit builds
Date: Mon, 23 Jun 2008 13:14:14 +1000
User-Agent: KMail/1.9.9
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       lkml <linux-kernel@vger.kernel.org>
References: <1213973051.3047.12.camel@castor.localdomain> <200806211926.15966.vda.linux@googlemail.com>
In-Reply-To: <200806211926.15966.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231314.14375.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 June 2008 03:26:15 Denys Vlasenko wrote:
> On Friday 20 June 2008 16:44, Richard Kennedy wrote:
> > reorder struct module to save space on 64 bit builds.
> > saves 1 cacheline_size  (128 on default x86_64 & 64 on AMD
> > Opteron/athlon) when CONFIG_MODULE_UNLOAD=y.
> >
> > Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> > ---
> >
> > Patch against 2.6.26-rc6. tested & running successfully on AMD64 desktop
> > machine. This patch reduces the data segment of each module by 1
> > cacheline size.
> >
> > I also compiled with this patch for 32 bit & there was no change in
> > size.
>
> Sometime ago I did something similar. I also shrank the struct module
> by ifdefing out fields which are not needed.
>
> The patch appeared to fell through the cracks.
>
> Here is it again with original submission text.

Thanks, I've put this in my tree.  There's some other module work going on, so 
it might need a little rework.

Cheers,
Rusty.
