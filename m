Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbZE1MRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbZE1MRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZE1MRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:17:45 -0400
Received: from main.gmane.org ([80.91.229.2]:60506 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbZE1MRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:17:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Date: Thu, 28 May 2009 12:17:32 +0000 (UTC)
Message-ID: <gvlvcs$ub5$1@ger.gmane.org>
References: <20090527175609.GB31861@flint.arm.linux.org.uk>
	<1243496236.3171.140.camel@pasglop>
	<20090528091513.GA14789@n2100.arm.linux.org.uk>
	<20090528.025739.16559619.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: iap-pxy-mow1.siemens.ru
User-Agent: Pan/0.132 (Waxed in Black)
Cc: devicetree-discuss@ozlabs.org, linux-arm-kernel@lists.arm.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> From: Russell King - ARM Linux
> <linux@arm.linux.org.uk> Date: Thu, 28 May 2009
> 10:15:13 +0100
> 
>> For example, how would an IrDA transceiver be expressed in OF?
> 
> As a child device node of the IRDA device, with associated properties.
> 
> You can express _ANYTHING_ using the OF device tree.  It is not even
> something to discuss, it's flexible enough.

Hmmm. How to express the following situation:
On one of my platforms (sharp tosa) the backlight controller
is separated into two parts: one sitting on SPI, one on the I2C.
The tricky part is that the I2C part is only available when some
of registers of SPI part are programmed in a specific way.

-- 
With best wishes
Dmitry


