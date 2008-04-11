Return-Path: <linux-kernel-owner+w=401wt.eu-S1761858AbYDKRnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761858AbYDKRnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760659AbYDKRnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:43:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46480
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760086AbYDKRnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:43:07 -0400
Date: Fri, 11 Apr 2008 10:43:06 -0700 (PDT)
Message-Id: <20080411.104306.93639801.davem@davemloft.net>
To: jochen@scram.de
Cc: galak@kernel.crashing.org, khali@linux-fr.org, scottwood@freescale.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, jonsmirl@gmail.com, laurentp@cse-semaphore.com
Subject: Re: [PATCH3/7] i2c: OF helpers for the i2c API
From: David Miller <davem@davemloft.net>
In-Reply-To: <47FF710D.2040208@scram.de>
References: <47FF710D.2040208@scram.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jochen Friedrich <jochen@scram.de>
Date: Fri, 11 Apr 2008 16:09:17 +0200

> +
> +config OF_I2C
> +	def_bool y
> +	depends on OF && PPC_OF && I2C
> +	help
> +	  OpenFirmware I2C accessors

I wouldn't mind trying to use this infrastructure on
sparc64, and I don't see any powerpc specific interfaces
being invoked, so if you could remove the PPC_OF
requirement I'd appreciate it.

Thanks.
