Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbZAVBft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbZAVBft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 20:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbZAVBfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 20:35:40 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:44602 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754830AbZAVBfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 20:35:40 -0500
Date: Thu, 22 Jan 2009 04:35:36 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Xie Xiaobo <X.Xie@freescale.com>,
       Konjin Lai <Konjin.Lai@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>
Subject: Re: [PATCH] mmc: Add driver for Freescale eSDHC controllers
Message-ID: <20090122013536.GA6008@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090114194631.GA25978@oksana.dev.rtsoft.ru> <533AEE7C-0605-43E9-BB9F-615BE6761202@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <533AEE7C-0605-43E9-BB9F-615BE6761202@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 09:43:50PM -0600, Kumar Gala wrote:
>
> On Jan 14, 2009, at 1:46 PM, Anton Vorontsov wrote:
>
>> From: Xie Xiaobo <X.Xie@freescale.com>
>>
>> This patch adds support for the Freescale Enhanced Secure Digital
>> Host Controller Interface as found in some Freescale PowerPC
>> microprocessors (e.g. MPC837x SOCs).
>>
>> Signed-off-by: Xie Xiaobo <X.Xie@freescale.com>
>> Signed-off-by: Konjin Lai <Konjin.Lai@freescale.com>
>> Signed-off-by: Joe D'Abbraccio <Joe.D'abbraccio@freescale.com>
>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>> ---
>> drivers/mmc/host/Kconfig  |    9 +
>> drivers/mmc/host/Makefile |    1 +
>> drivers/mmc/host/esdhc.c  | 1321 ++++++++++++++++++++++++++++++++++++ 
>> +++++++++
>> drivers/mmc/host/esdhc.h  |  255 +++++++++
>> 4 files changed, 1586 insertions(+), 0 deletions(-)
>> create mode 100644 drivers/mmc/host/esdhc.c
>> create mode 100644 drivers/mmc/host/esdhc.h
>
> Want to work some device tree docs for this.

Will do. Though all the needed nodes already in the .dts files. ;-)

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
