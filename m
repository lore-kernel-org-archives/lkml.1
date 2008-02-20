Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbYBTReh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbYBTReh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYBTReK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:34:10 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50852 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbYBTReJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:34:09 -0500
Date: Wed, 20 Feb 2008 18:34:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 5/6] regulator: regulator framework build.
Message-ID: <20080220173419.GB19950@uranus.ravnborg.org>
References: <1203527361.4071.93.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203527361.4071.93.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
> new file mode 100644
> index 0000000..3f70871
> --- /dev/null
> +++ b/drivers/regulator/Makefile
> @@ -0,0 +1,9 @@
> +#
> +# Makefile for regulator drivers.
> +#
> +
> +obj-$(CONFIG_REGULATOR) += reg-core.o
> +
Replace this
> +ifeq ($(CONFIG_REGULATOR_DEBUG),y)
> +	EXTRA_CFLAGS		+= -DDEBUG
> +endif

with this:
> +ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG

	Sam
