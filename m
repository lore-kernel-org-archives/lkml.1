Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYFEJLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYFEJLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYFEJLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:11:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46459 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752040AbYFEJLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:11:15 -0400
Date: Thu, 5 Jun 2008 09:54:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: stan.cunningham@yahoo.com
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       legal@narasimha.gpl-violations.org, license-violation@gnu.org
Subject: Re: ASUS SplashTop and Phoenix Hyperspace infringing kernel
 copyright and GPL
Message-ID: <20080605095428.7cd00d7a@core>
In-Reply-To: <98404.93587.qm@web57413.mail.re1.yahoo.com>
References: <483205C8.8050108@redhat.com>
	<98404.93587.qm@web57413.mail.re1.yahoo.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>distributing the binary to customers who buy motherboards and laptops. It is therefore ASUS' >obligation to provide the the "complete machine-readable" source code to those customers. I've

>ASUS _cannot_ hide behind section 3c by simply pointing customers to
>SplashTop/DeviceVM's website because neither ASUS nor DeviceVM are
>noncommercial, and in fact, they are _selling_ motherboards and laptops
>containing GPLv2 software. 

Thst isn't a simple question and rather depends upon the contractual
arrangements don't you think ? If I offer to supply it by CD your
software will be delivered by the postal service, from whom you did not
buy the product.

A company might have liability for the failure of its agents to perform
services but that is a different question

> Now I have a theory as to why ASUS/DeviceVM are posting patches instead of the full kernel: it makes it harder for copyright holders to find out that a driver or modification is missing from the patchset. ASUS can claim that the differences in behavior between a patched mainline kernel and the

Let me propose a different theory: ASUS thought a smaller 12MB download
would be more convenient and useful to their userbase.

> Finally, I'd like to bring your attention to an article (http://community.zdnet.co.uk/blog/0,1000000567,10008346o-2000331761b,00.htm) in which DeviceVM states that " the part of Splashtop that is embedded into BIOS and achieves the instant-on first screen is based on a proprietary RTOS that DeviceVM developed." This sounds less of a bootloader and more like a Virtual Machine because it apparently brings up Linux from a frozen state without booting it. In any case, I urge someone with the hardware and know-how to check if this "proprietary RTOS" uses any EXPORT_SYMBOL_GPL.

It's a mini virtual machine using the cpu extensions. It really shouldn't
need any deeply magical kernel patches except maybe interfaces to
virtualised drivers.

I really don't see a big problem providing ASUS are including the written
offer in the manual somewhere or have an agreement with devicevm to act
as their GPL fulfilment - and DeviceVM do so.

What we *really* need to happen is to get DeviceVM/Phoenix merging their
work into the base kernel tree nicely and cleanly.

Alan
