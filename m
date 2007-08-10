Return-Path: <linux-kernel-owner+w=401wt.eu-S934624AbXHJKAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934624AbXHJKAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 06:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXHJKAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 06:00:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:48913 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbXHJKA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 06:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OCA9p5Ys2IAPTyOW9g7bWxb/qJ/5X/H/CdXq2cQ5hYO1tgBH6XsCbnMDW9bbMIpeKnsFJxfwO/vO8Em5SCpjkYn15MZRT27tMGGTzpJuBKE6O3rV7pQn+4zCMf1uTNfBdHca/1C5hYSEL+FJGVc9W1bLKE5jFqw1tYdcrT+gxds=
Message-ID: <c88e466f0708100300l401ef479sbce5eed22b869de2@mail.gmail.com>
Date: Fri, 10 Aug 2007 12:00:28 +0200
From: "Michel Benoit" <murpme@gmail.com>
To: "Pierre Savary" <pierre.savary@kerlink.fr>
Subject: Re: [PATCH] at91 pm: Compilation fix for at91sam926x
Cc: "Marc Pignat" <marc.pignat@hevs.ch>,
       "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>,
       trivial@kernel.org, linux-kernel@vger.kernel.org,
       "Andy Herzig" <andrew.herzig@ngc.com>, andrew@sanpeople.com,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <3858727143598039860@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186661447.6370.19.camel@leoh9-18574.nges.northgrum.com>
	 <018a01c7dad3$10ca8190$dcc4af0a@atmel.com>
	 <200708100912.35485.hjk@linutronix.de>
	 <200708100933.46235.marc.pignat@hevs.ch>
	 <3858727143598039860@unknownmsgid>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

I'm also using power management on the at91sam9260.

> About SDRAm self refresh mode on at91sam926x, in fact AT91_SDRAMC_SRR
> doesn't exist but the new register is AT91_SDRAMC_LPR. So for instance, you
> can replace at91_sys_write(AT91_SDRAMC_SRR, 1) by
> at91_sys_write(AT91_SDRAMC_LPR, AT91_SDRAMC_LPCB_SELF_REFRESH).

I have also made that change in pm.c.  I've tested it with 2.6.20.4
and it seems to work.

> Currently I work on the power management on at91sam9260 so when I will
> finish my work, I could give you my files.

Please post your mods to the list when you are finished.  I will
gladly help you test them.
Are you going to implement slow clock standby mode?

Michel
