Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZBZURS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZBZURS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZBZURG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:17:06 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:37824 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbZBZURF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:17:05 -0500
Subject: Re: [PATCH 2/2] regulator: Fix get_mode() for WM835x DCDCs
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1235676260-19696-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1235676260-19696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1235676260-19696-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 20:17:00 +0000
Message-Id: <1235679420.31223.50.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 19:24 +0000, Mark Brown wrote:
> The WM835x regulators need a different register checking for force
> mode on each DCDC. Previously the force mode status for DCDC1 was
> checked.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/wm8350-regulator.c |   24 ++++++++++++++++++------
>  1 files changed, 18 insertions(+), 6 deletions(-)
> 

Applied.

Thanks

Liam

