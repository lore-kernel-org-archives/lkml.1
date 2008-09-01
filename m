Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbYIAOCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbYIAOCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYIAOCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:02:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51487 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751333AbYIAOCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:02:30 -0400
Date: Mon, 1 Sep 2008 15:02:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Horstmann <gineera@aspect135.co.uk>
Cc: Bryan Wu <cooloney@kernel.org>, Cliff Cai <cliff.cai@analog.com>,
       alsa-devel@alsa-project.org, liam.girdwood@wolfsonmicro.com,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/4] ASOC: WM8731 codec: add SPI support
	as well as I2C
Message-ID: <20080901140227.GA17103@rakim.wolfsonmicro.main>
Mail-Followup-To: Alan Horstmann <gineera@aspect135.co.uk>,
	Bryan Wu <cooloney@kernel.org>, Cliff Cai <cliff.cai@analog.com>,
	alsa-devel@alsa-project.org, liam.girdwood@wolfsonmicro.com,
	linux-kernel@vger.kernel.org
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org> <1219829968-6431-4-git-send-email-cooloney@kernel.org> <200809011452.08070.gineera@aspect135.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809011452.08070.gineera@aspect135.co.uk>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 02:52:08PM +0100, Alan Horstmann wrote:

> in order to force use of SPI when (CONFIG_SND_SOC_WM8731_SPI) and (CONFIG_I2C) 
> are both defined.  Or have we misunderstood the intention?  This is in 2 
> other places also in the patch.

I've reworked the patch to allow a single kernel image to support both
I2C and SPI which sidesteps this problem.  I'll post this later today.
