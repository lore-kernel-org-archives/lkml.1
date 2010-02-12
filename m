Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0BLLX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:23:28 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:38853 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab0BLLXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:23:19 -0500
Subject: Re: [PATCH 2.6.33] regulator: Fix display of null constraints for
 regulators
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <1265916048-9596-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1265916048-9596-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 11:23:14 +0000
Message-ID: <1265973794.3231.4.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-11 at 19:20 +0000, Mark Brown wrote:
> If the regulator constraints are empty and there is no voltage
> reported then nothing will be added to the text displayed for the
> constraints, leading to random stack data being printed. This is
> unlikely to happen for practical regulators since most will at
> least report a voltage but should still be fixed.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@kernel.org
> ---
> 

Applied.

> Not super critical for 2.6.33 but at least worth considering.

Agreed, I will issue pull request for this for 2.6.33.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

