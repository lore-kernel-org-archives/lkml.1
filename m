Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbZIPMaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbZIPMaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbZIPMaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:30:02 -0400
Received: from khc.piap.pl ([195.187.100.11]:59217 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbZIPMaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:30:00 -0400
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
	<m3k4zzdimy.fsf@intrepid.localdomain>
	<1253053609.3273.139.camel@linux-1lbu>
	<m33a6nddvd.fsf@intrepid.localdomain>
	<1253089566.3273.152.camel@linux-1lbu>
Date: Wed, 16 Sep 2009 14:30:01 +0200
In-Reply-To: <1253089566.3273.152.camel@linux-1lbu> (Steve Chen's message of
	"Wed, 16 Sep 2009 03:26:06 -0500")
Message-ID: <m3ljkfoywm.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Chen <schen@mvista.com> writes:

> +config OLD_CPU_DELAY
> +	depends on CPU_32v3 || CPU_32v4 || CPU_32v4T
> +	bool "Accurate delays for some older CPUs"
> +	def_bool n
> +	help
> +	  Try enable this if observing longer than expected delays and need
> +	  more accuracy.  May cause instability in some CPUs.
> +

There is still this uncertain "accurate" in the text. Why don't just

+	bool "Different delay() code for some older CPUs"
-- 
Krzysztof Halasa
