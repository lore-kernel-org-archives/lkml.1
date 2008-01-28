Return-Path: <linux-kernel-owner+w=401wt.eu-S1759730AbYA1MM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730AbYA1MM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYA1MMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:12:20 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60645 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbYA1MMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:12:20 -0500
Date: Mon, 28 Jan 2008 14:12:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>, Hans Verkuil <hverkuil@xs4all.nl>,
       v4l-dvb-maintainer@linuxtv.org,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.25 regression: VIDEO_DEV=y/m, I2C=n
	compile error
Message-ID: <20080128121245.GG1001@does.not.exist>
References: <20080127185216.GB13300@does.not.exist> <20080127223334.696fce6e@gaivota> <20080128084001.GB1001@does.not.exist> <Pine.LNX.4.58.0801280053010.15635@shell4.speakeasy.net> <20080128094912.1848eacd@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080128094912.1848eacd@gaivota>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 09:49:12AM -0200, Mauro Carvalho Chehab wrote:
> > Maybe the kernel headers should provide a couple macros for testing
> > configs, since people get it wrong over and over again?
> > 
> > #define CONFIG_ON(x) (defined(CONFIG_##x) || defined(CONFIG_##x##_MODULE))
> > #define CONFIG_AVAIABLE(x) (defined(CONFIG_##x) || (defined(MODULE) && defined(CONFIG_##x##_MODULE)))
> 
> Seems a good idea to me.
> > 
> > Not sure what to do about VIDEO_DEV=y, I2C=m.  It should be possible except
> > for this function.
> 
> I don't see much sense on allowing v4l2-common being in-kernel, while having
> I2C as module. Also, creating a separate module for just a single function
> seems to be overkill.
> 
> IMO, in this specific case, v4l2-common should also be a module. Not sure,
> however,the better syntax on Kconfig. Once, someone suggested a very weird
> syntax, like:
> 
> 	depends on I2C if I2C

Why does anyone want to introduce such a weird syntax for something 
that already works with the simple

	depends on I2C || I2C=n

?

> Cheers,
> Mauro

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

