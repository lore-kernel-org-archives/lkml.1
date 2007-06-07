Return-Path: <linux-kernel-owner+w=401wt.eu-S966836AbXFGWIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966836AbXFGWIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966643AbXFGWGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:06:09 -0400
Received: from khc.piap.pl ([195.187.100.11]:47399 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966677AbXFGWGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:06:07 -0400
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
References: <20070607162251.5f291325@the-village.bc.nu>
	<m3wsyfzcpt.fsf@maximus.localdomain>
	<200706072232.37051.s0348365@sms.ed.ac.uk>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 08 Jun 2007 00:06:05 +0200
In-Reply-To: <200706072232.37051.s0348365@sms.ed.ac.uk> (Alistair John Strachan's message of "Thu, 7 Jun 2007 22:32:36 +0100")
Message-ID: <m3sl93zagi.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan <s0348365@sms.ed.ac.uk> writes:

> I personally buy the argument that 80 cols helps remind people that they've 
> used too many indentation depths and should redesign their code.
> I think it's 
> a good thing to stick to where possible, even if just from a design 
> perspective.

How many is too many? A function with 2 "if" means 3 tabs = 24 characters
for just indentation. Add a printk(KERN_DEBUG "\n"); and you can print
ca. 30 characters without having to break the string. This is crazy.

> There are some cases such as the one Alan has pointed out here where being 
> strictly 80 cols seems more destructive than useful, but those are the 
> exception, not the rule (IMO).

Well... I was forced to split functions making the code less readable
and more complicated just to avoid these 80-columns. A short function
with more indent levels may be way more readable than a redesigned one
with this requirement in mind.

I'd just state the code has to be readable and laid out with some sanity
but 80 columns give us nothing WRT this.

We already review new code and spot such problems (and smaller ones)
without using the 80-cols rule.
-- 
Krzysztof Halasa
