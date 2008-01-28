Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbYA1MZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbYA1MZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYA1MY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:24:59 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37593 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbYA1MY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:24:58 -0500
Date: Mon, 28 Jan 2008 14:25:23 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, v4l-dvb-maintainer@linuxtv.org,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.25 regression: VIDEO_DEV=y/m, I2C=n
	compile error
Message-ID: <20080128122523.GH1001@does.not.exist>
References: <20080127185216.GB13300@does.not.exist> <20080127223334.696fce6e@gaivota> <20080128084001.GB1001@does.not.exist> <Pine.LNX.4.58.0801280053010.15635@shell4.speakeasy.net> <Pine.LNX.4.64.0801281314450.1185@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801281314450.1185@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 01:17:10PM +0100, Jan Engelhardt wrote:
> 
> On Jan 28 2008 01:05, Trent Piepho wrote:
> 
> >Maybe the kernel headers should provide a couple macros for testing
> >configs, since people get it wrong over and over again?
> >
> >#define CONFIG_ON(x) (defined(CONFIG_##x) || defined(CONFIG_##x##_MODULE))
> >#define CONFIG_AVAIABLE(x) (defined(CONFIG_##x) || (defined(MODULE) && defined(CONFIG_##x##_MODULE)))
>                ^AVAILABLE(x)
> 
> What's the difference between these two?
> 
> CONFIG_x_MODULE will never be defined if MODULE is not, so defined(MODULE)
> seems redundant.
>...

It's not redundant - x is the module you want to use something from, and 
MODULE is defined when the code you are working on gets compiled as a 
module.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

