Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbYIAOAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYIAOAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYIAOAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:00:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:48159 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYIAOAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:00:32 -0400
Subject: Re: [alsa-devel] [PATCH 3/4] ASOC: WM8731 codec: add SPI support
	as well as I2C
From: Liam Girdwood <lrg@kernel.org>
To: Alan Horstmann <gineera@aspect135.co.uk>
Cc: Bryan Wu <cooloney@kernel.org>, Cliff Cai <cliff.cai@analog.com>,
       alsa-devel@alsa-project.org, liam.girdwood@wolfsonmicro.com,
       broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
In-Reply-To: <200809011452.08070.gineera@aspect135.co.uk>
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
	 <1219829968-6431-4-git-send-email-cooloney@kernel.org>
	 <200809011452.08070.gineera@aspect135.co.uk>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 15:00:16 +0100
Message-Id: <1220277616.6499.119.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 14:52 +0100, Alan Horstmann wrote:
> We have just started trying this out as an alternative to i2c, and picked out 
> the following:
> 
> On Wednesday 27 August 2008 10:39, Bryan Wu wrote:
> > -#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
> > +#if defined (CONFIG_I2C) || defined (CONFIG_I2C_MODULE) && !defined
> > (CONFIG_SND_SOC_WM8731_SPI)
> 
> I think this needs extra brackets round the ||'s before the && thus:
> 
> > +#if (defined (CONFIG_I2C) || defined (CONFIG_I2C_MODULE)) && !defined
> > (CONFIG_SND_SOC_WM8731_SPI)
> 
> in order to force use of SPI when (CONFIG_SND_SOC_WM8731_SPI) and (CONFIG_I2C) 
> are both defined.  Or have we misunderstood the intention?  This is in 2 
> other places also in the patch.
> 

It may be simpler to only have CONFIG_SND_SOC_WM8731_SPI and
CONFIG_SND_SOC_WM8731_I2C definitions for all the codec drivers. These
would be set by machine Kconfig. 

Liam

