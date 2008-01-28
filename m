Return-Path: <linux-kernel-owner+w=401wt.eu-S1760730AbYA1MRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730AbYA1MRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYA1MRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:17:12 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58479 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYA1MRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:17:11 -0500
Date: Mon, 28 Jan 2008 13:17:10 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Adrian Bunk <bunk@kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, v4l-dvb-maintainer@linuxtv.org,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.25 regression: VIDEO_DEV=y/m, I2C=n
 compile error
In-Reply-To: <Pine.LNX.4.58.0801280053010.15635@shell4.speakeasy.net>
Message-ID: <Pine.LNX.4.64.0801281314450.1185@fbirervta.pbzchgretzou.qr>
References: <20080127185216.GB13300@does.not.exist> <20080127223334.696fce6e@gaivota>
 <20080128084001.GB1001@does.not.exist> <Pine.LNX.4.58.0801280053010.15635@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 28 2008 01:05, Trent Piepho wrote:

>Maybe the kernel headers should provide a couple macros for testing
>configs, since people get it wrong over and over again?
>
>#define CONFIG_ON(x) (defined(CONFIG_##x) || defined(CONFIG_##x##_MODULE))
>#define CONFIG_AVAIABLE(x) (defined(CONFIG_##x) || (defined(MODULE) && defined(CONFIG_##x##_MODULE)))
               ^AVAILABLE(x)

What's the difference between these two?

CONFIG_x_MODULE will never be defined if MODULE is not, so defined(MODULE)
seems redundant.

>Would save typing too.

Yes please add it. (But don't try to convert any subsystems - deep dev phase)


