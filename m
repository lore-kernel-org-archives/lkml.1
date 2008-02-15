Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYBOQkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYBOQkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYBOQkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:40:04 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2531 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYBOQkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:40:02 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 4/4] Voltage and current regulator framework
Date: Fri, 15 Feb 2008 17:39:56 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1203084895.3466.219.camel@localhost.localdomain>
In-Reply-To: <1203084895.3466.219.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802151739.57751.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Regulator framework core :-

[ ... snip ... ]

> +void regulator_put(struct regulator *regulator)
> +{
> +	struct regulator_cdev *rcdev = regulator->rcdev;
> +
> +	if (regulator == NULL || IS_ERR(regulator))
> +		return;

Check after use.

Regards,

	Mariusz
