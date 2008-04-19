Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYDSEEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYDSEEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 00:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYDSEEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 00:04:39 -0400
Received: from ozlabs.org ([203.10.76.45]:50427 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbYDSEEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 00:04:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18441.28496.84724.411784@cargo.ozlabs.ibm.com>
Date: Sat, 19 Apr 2008 14:04:32 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: Kumar Gala <galak@kernel.crashing.org>, Jean Delvare <khali@linux-fr.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] [POWERPC] i2c: fix build breakage introduced by OF helpers
In-Reply-To: <4808AEC7.8040000@scram.de>
References: <4808AEC7.8040000@scram.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich writes:

> Fix build breakage introduced in commit
> "[POWERPC] i2c: OF helpers for the i2c API".
> If i2c-core is compiled as module, the helper needs to be
> compiled as module, as well. Rename i2c.c to of_i2c.c to
> avoid name space conflict.

Actually, since only powerpc has irq_of_parse_and_map, I'm now
inclined to think that drivers/of/i2c.c should live under arch/powerpc
for now, or at the least its option should depend on PPC_OF.

Paul.
