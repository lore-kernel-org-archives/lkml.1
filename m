Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYABCf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYABCf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYABCfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:35:51 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:39799 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYABCfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:35:50 -0500
Subject: Re: [BUG] crash - modules l440gx and parport_pc interfere
From: Jon Masters <jonathan@jonmasters.org>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <80365890@web.de>
References: <80365890@web.de>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 01 Jan 2008 21:35:11 -0500
Message-Id: <1199241316.3300.57.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-01 at 20:57 +0100, devzero@web.de wrote:
> there seems some weird interference between l440gx and parport_pc modules
> 
> i can reproduceable crash my box by either:
> 
> modprobe parport_pc;modprobe l440gx;rmmod parport_pc
> 
> or
> 
> modprobe l440gx; modprobe parport_pc;rmmod parport_pc

Stinks of a locking problem. Have you compiled in any of the kernel
debugging features? Did you build the kernel, or is it a vendor one?

Jon.

