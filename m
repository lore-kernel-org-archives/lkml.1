Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZCDKBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZCDKBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZCDKB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:01:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33346 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751084AbZCDKBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:01:25 -0500
Date: Wed, 4 Mar 2009 09:57:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, pgnet.trash@gmail.com
Subject: Re: [PATCH 2.6.29-rc7 2/2] x86: disallow DAC for MCP51 PCI bridge
Message-ID: <20090304095727.707ac18c@lxorguk.ukuu.org.uk>
In-Reply-To: <49ADE9D3.6080000@kernel.org>
References: <49ADE82D.40103@kernel.org>
	<49ADE9D3.6080000@kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Organization: None.. I'm free I'm free bwhahahahaha!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Mar 2009 11:39:15 +0900
Tejun Heo <tj@kernel.org> wrote:

> MCP51 corrupts DAC transfers.  Disallow it.  Reported by pgnet on
> bnc#463829.

So you have a single piece of evidence as I read it - from a single
board that represents system with a very common chipset and no supporting
errata information from the vendor.

That bug could easily be a faulty motherboard or dodgy connector or a
specific hardware compatibility issue between two specific components. I
don't think that can be considered sufficient evidence for adding
sledgehammer sized workarounds that harm everyone elses performance and
cripples such systems for certain kinds of work (eg video)

Insufficient evidence and google searches and other bug searches don't
seem to be turning up any parallel cases so for the moment At the very
least someone needs to reproduce the hardware configuration and see the
same problem, and then repeat with a different DAC enabled card.

I don't believe this patch should go in ... yet. More information/testing
is needed.

Alan
