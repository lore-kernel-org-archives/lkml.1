Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZHJVMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZHJVMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 17:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZHJVMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 17:12:46 -0400
Received: from dan.rpsys.net ([93.97.175.187]:63809 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbZHJVMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 17:12:46 -0400
Subject: Re: ads7846: clean up, fix pressure reporting
From: Richard Purdie <rpurdie@rpsys.net>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@ucw.cz>, dtor@mail.ru, linux-input@vger.kernel.org,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com
In-Reply-To: <1249813293.4334.24.camel@utx.utx.cz>
References: <20090807180941.GF1728@ucw.cz>
	 <1249813293.4334.24.camel@utx.utx.cz>
Content-Type: text/plain; charset=utf-8
Date: Mon, 10 Aug 2009 22:10:48 +0100
Message-Id: <1249938648.22268.190.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-09 at 12:21 +0200, Stanislav Brabec wrote:
> Pavel Machek wrote:
> > Fix pressure reporting, and clean up debug prints.
> 
> Thanks.
> 
> I see much bigger problem with both the old driver and the new ads7846
> driver (2.6.30): They are very noisy on my spitz. When you tap to one
> place, keep stylus pressed and just read values, you get 20-200 pixels
> long pointer motion trip each second.
> 
> According to Cyril Hrubiš, it is caused by the electrical noise that
> originates in the LCD display. The driver needs to read data
> synchronously with the LCD refresh. He already made the fix for collie
> several years ago.

This is what I've been led to believe as well. There was code in the old
driver to try and avoid this by only taking touchscreen readings when
the LCD wasn't electrically active but it sounds like this has become
broken :(.

Cheers,

Richard


-- 
Richard Purdie
Intel Open Source Technology Centre

