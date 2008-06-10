Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbYFJKTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbYFJKTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYFJKTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:19:22 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:37750 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbYFJKTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:19:21 -0400
Date: Tue, 10 Jun 2008 12:18:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ben Dooks <ben@fluff.org>
Cc: Uli Luckas <u.luckas@road.de>, David Brownell <david-b@pacbell.net>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, adaplas@gmail.com,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: [i2c] Frame buffers and early i2c
Message-ID: <20080610121853.26b4d432@hyperion.delvare>
In-Reply-To: <20080610100249.GA30539@fluff.org.uk>
References: <200806091647.42757.u.luckas@road.de>
	<200806092359.36080.u.luckas@road.de>
	<20080610082527.0e6d643a@hyperion.delvare>
	<200806101131.19763.u.luckas@road.de>
	<20080610100249.GA30539@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 11:02:50 +0100, Ben Dooks wrote:
> On Tue, Jun 10, 2008 at 11:31:19AM +0200, Uli Luckas wrote:
> > Just changing the initcall to subsys really did the trick. I thought, this was 
> > the first thing I tried and I thought it crashed my device. But obviousely I 
> > had some other problem.
> > If Russell gives his Ack, could this be pushed upstream through i2c?
> 
> Does this work if the code is built as a module?

subsys_initcall degrades to module_init in modules, so Uli's patch
doesn't change anything in that case.

> BTW, if people do have these sort of dependencies, then modules
> are another way of sorting out the load order, unless you have
> the module autoload enabled.

-- 
Jean Delvare
