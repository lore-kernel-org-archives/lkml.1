Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZIOVgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZIOVgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZIOVgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:36:13 -0400
Received: from khc.piap.pl ([195.187.100.11]:45371 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbZIOVgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:36:13 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Steve Chen <schen@mvista.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       Marek Vasut <marek.vasut@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
	<20090915103739.GA19519@elf.ucw.cz>
	<1253017761.3273.117.camel@linux-1lbu>
	<200909151541.08852.marek.vasut@gmail.com>
	<1253032210.3273.128.camel@linux-1lbu>
	<94a0d4530909151158y489a96e3x63ff932c713822b0@mail.gmail.com>
	<1253043875.3273.131.camel@linux-1lbu>
Date: Tue, 15 Sep 2009 23:04:37 +0200
In-Reply-To: <1253043875.3273.131.camel@linux-1lbu> (Steve Chen's message of
	"Tue, 15 Sep 2009 14:44:35 -0500")
Message-ID: <m3k4zzdimy.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Chen <schen@mvista.com> writes:

> +config OLD_CPU_DELAY
> +	depends on CPU_32v3 || CPU_32v4 || CPU_32v4T
> +	bool "Accurate delays"
> +	def_bool n
> +	help
> +	  Enable if observing longer than expected delays and need more
> +	  accuracy.  This only applies to older CPUs.
> +

If it's that simple then why not enable the extra delay code
unconditionally when compiling for those CPUs?

We don't need "do something better" options.
-- 
Krzysztof Halasa
