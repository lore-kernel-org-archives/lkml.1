Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbZCSSMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbZCSSMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbZCSSJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:09:33 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:47667 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760257AbZCSSJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:09:32 -0400
Subject: Re: [PATCH 2/2] regulator: Support disabling of unused regulators
 by machines
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1237232194-24113-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1237232194-24113-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1237232194-24113-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 18:09:28 +0000
Message-Id: <1237486168.6781.341.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 19:36 +0000, Mark Brown wrote:
> At present it is not possible for machine constraints to disable
> regulators which have been left on when the system starts, for example
> as a result of fixed default configurations in hardware. This means that
> power may be wasted by these regulators if they are not in use.
> 
> Provide intial support for this with a late_initcall which will disable
> any unused regulators if the machine has enabled this feature by calling
> regulator_has_full_constraints(). If this has not been called then print
> a warning to encourage users to fully specify their constraints so that
> we can change this to be the default behaviour in future.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c          |   92 +++++++++++++++++++++++++++++++++++++
>  include/linux/regulator/machine.h |    2 +
>  2 files changed, 94 insertions(+), 0 deletions(-)
> 

Applied.

Thanks

Liam

