Return-Path: <linux-kernel-owner+w=401wt.eu-S939073AbXGUPch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939073AbXGUPch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbXGUPc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:32:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50561 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292AbXGUPc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:32:26 -0400
Date: Sat, 21 Jul 2007 17:32:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Robert Beckett <bob.beckett@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: try_module_get question
In-Reply-To: <469B712D.80208@googlemail.com>
Message-ID: <Pine.LNX.4.64.0707211731440.21737@fbirervta.pbzchgretzou.qr>
References: <469B712D.80208@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 16 2007 14:22, Robert Beckett wrote:
> Hi all,
>
> Im a newcomer to kernel development, and have my first question :
>
> I want to create a small module that simply powers on an FPGA, and powers it
> off when it is released. Two other modules will then depend on this module and
> control different devices programmed into the FPGA.

How do they depend on it?

> So that the shared module
> does not get removed before any of the device drivers, I want to do a
> try_module_get from each driver targeting the shared module. What is the
> easiest way to get a reference to the shared module?
>
> My current thought is to export a function that will return a reference to it
> (using THIS_MODULE from the shared module). The device driver modules can then
> try_module_get the returned module. Is this the best way to do this?
>
> Is there an alternative way? maybe based on a similar system to the device /
> driver matching code?
> There seem to be a lot of FAQs online saying that you need to get and put a
> module before calling any function that may stall for example, but they dont
> tell you how to get the module reference to use.
>
> Or am I just missing something obvious?
>
> Thanks
>
> Robert Beckett.

	Jan
-- 
