Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbXFOHXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbXFOHXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 03:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbXFOHXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 03:23:18 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3619 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbXFOHXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 03:23:18 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 4/6] SM501 MFD driver updates
Date: Fri, 15 Jun 2007 09:23:11 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070613130953.983863758@localhost> <20070613131159.823779700@localhost>
In-Reply-To: <20070613131159.823779700@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150923.11657.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> +static int sm501_check_clocks(struct sm501_devdata *sm)
> +{
> +	unsigned long pwrmode = readl(sm->regs + SM501_CURRENT_CLOCK);
> +	unsigned long msrc = (pwrmode & SM501_POWERMODE_M_SRC);
> +	unsigned long m1src = (pwrmode & SM501_POWERMODE_M1_SRC);
> +
> +	return ((msrc == 0 && m1src != 0) || (msrc == 0 && msrc != 0));
                                              ^^^^^^^^^^^^^^^^^^^^^^
This will always be false. Typo?

	Mariusz
