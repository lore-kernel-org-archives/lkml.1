Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbXIBWIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbXIBWIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXIBWIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:08:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41168 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbXIBWIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:08:47 -0400
Date: Sun, 2 Sep 2007 15:07:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: <colin.michael@o2online.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [patch] enable userspace cpu core voltage control with
 acpi-cpufreq
Message-ID: <20070902150735.010edd66@laptopd505.fenrus.org>
In-Reply-To: <200709021441.l82EfWCe022642@mail.mc.o2online.de>
References: <200709021441.l82EfWCe022642@mail.mc.o2online.de>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007 16:41:32 +0200 (CEST)
<colin.michael@o2online.de> wrote:

> please add me as CC to any answear to that post.
> 
> 
> Hello, 
> i want to make a patch known that provides a userspace interface to
> control the core voltage of a computer processor(s).

(of course doing this scares the bejeezes out of me ;)

One request; can you please make it so that the code marks the kernel
as tainted when such out-of-spec settings are used? 
(pick a taint flag, any taint flag, I thought we had one for
overclocking (which is effectively what you're doing) but it seems that
one got removed)...
This way if people get an oops at least it's clear for people that look
at such oopses that something funky is going on, and that they can then
prioritize looking at such an oops accordingly..



Greetings,
   Arjan van de Ven
