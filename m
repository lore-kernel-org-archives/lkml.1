Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbXIMOc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbXIMOc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbXIMOcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:32:47 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:52357 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbXIMOcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:32:46 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3] Make the pr_*() family of macros in kernel.hcomplete
Date: Thu, 13 Sep 2007 07:32:37 -0700
Message-ID: <598D5675D34BE349929AF5EDE9B03E27014FA178@az33exm24.fsl.freescale.net>
In-Reply-To: <1189660274.19708.125.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v3] Make the pr_*() family of macros in kernel.hcomplete
Thread-Index: Acf1xInBGQQ8XhaxQAqAUUUagmkwywATTlQg
References: <11896151802410-git-send-email-Emilian.Medve@Freescale.com> <Pine.LNX.4.64.0709122003410.22467@fbirervta.pbzchgretzou.qr> <598D5675D34BE349929AF5EDE9B03E27014F9FDA@az33exm24.fsl.freescale.net> <1189660274.19708.125.camel@localhost>
From: "Medve Emilian-EMMEDVE1" <Emilian.Medve@freescale.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       <i2c@lm-sensors.org>, <linux-omap-open-source@linux.omap.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe,


> I expect all the kernel logging functions to be
> overhauled eventually.
> 
> I'd prefer a mechanism that somehow supports
> identifying complete messages.  I think the new
> pr_<level> functions are not particularly useful
> without a mechanism to avoid or identify multiple
> processors or threads interleaving partial in-progress
> multiple statement messages.

I agree with you that one can think and propose an improved kernel
logging system, but that might be an incremental effort. For now,
patches like the ones you or I sent are a step in the general direction
of improving kernel logging, fix an inconsistency and  increase the
probability of people logging kernel message as intended (i.e. at a
minimum, with a loglevel). I don't think that this hurts or delays the
perceived urgency of getting a sub-optimal kernel logging mechanism...

> At some point, sooner or later, the logging functions
> will be improved.  Apparently, more likely later.

I'm not sure way must it be later or why the resistance about a little
better and sooner.


Cheerios,
Emil.
