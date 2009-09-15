Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZIOWUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZIOWUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 18:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZIOWUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 18:20:42 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:58542 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZIOWUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 18:20:41 -0400
Subject: Re: [PATCH] arm: remove unused code in delay.S
From: Steve Chen <schen@mvista.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       Marek Vasut <marek.vasut@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <m3k4zzdimy.fsf@intrepid.localdomain>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
	 <20090915103739.GA19519@elf.ucw.cz> <1253017761.3273.117.camel@linux-1lbu>
	 <200909151541.08852.marek.vasut@gmail.com>
	 <1253032210.3273.128.camel@linux-1lbu>
	 <94a0d4530909151158y489a96e3x63ff932c713822b0@mail.gmail.com>
	 <1253043875.3273.131.camel@linux-1lbu>
	 <m3k4zzdimy.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 17:26:49 -0500
Message-Id: <1253053609.3273.139.camel@linux-1lbu>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 23:04 +0200, Krzysztof Halasa wrote:
> Steve Chen <schen@mvista.com> writes:
> 
> > +config OLD_CPU_DELAY
> > +	depends on CPU_32v3 || CPU_32v4 || CPU_32v4T
> > +	bool "Accurate delays"
> > +	def_bool n
> > +	help
> > +	  Enable if observing longer than expected delays and need more
> > +	  accuracy.  This only applies to older CPUs.
> > +
> 
> If it's that simple then why not enable the extra delay code
> unconditionally when compiling for those CPUs?
> 
> We don't need "do something better" options.

If I know for sure that these are the processors that need that block of
code, your suggestion makes perfect sense.  Unfortunately, I don't know.
My primary goals are

1.  Put a stop to this thread (so far I have failed miserably)
2.  Document that block of code.
3.  If it makes someone's life easier.. it would be a bonus.

Steve


