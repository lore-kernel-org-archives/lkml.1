Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0BLLYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:24:21 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:14884 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0BLLYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:24:19 -0500
Subject: Re: [PATCH] regulator: Provide optional dummy regulator for
 consumers
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Rapoport <mike@compulab.co.il>, Grazvydas Ignotas <notasas@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1265969888-16946-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1265918499-9583-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1265969888-16946-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 11:24:15 +0000
Message-ID: <1265973855.3231.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 10:18 +0000, Mark Brown wrote:
> In order to ease transitions with drivers are boards start using regulators
> provide an option to cause all regulator_get() calls to succeed, with a
> dummy always on regulator being supplied where one has not been configured.
> A warning is printed whenever the dummy regulator is used to aid system
> development.
> 
> This regulator does not implement any regulator operations but will allow
> simple consumers which only do enable() and disable() calls to run. It
> is kept separate from the fixed voltage regulator to avoid Kconfig
> confusion on the part of users when it is extended to allow boards to
> explicitly use the dummy regulator to simplify cases where the majority
> of supplies are from fixed regulators without software control.
> 
> This option is currently only effective for systems which do not specify
> full constriants. If required an override could also be provided to allow
> these systems to use the dummy regulator, though it is likely that
> unconfigured supplies on such systems will lead to error due to
> regulators being powered down more aggressively when not in use.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

