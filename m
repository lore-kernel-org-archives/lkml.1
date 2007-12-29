Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXL2Nqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXL2Nqy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 08:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXL2Nqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 08:46:46 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:46882 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbXL2Nqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 08:46:46 -0500
Subject: Re: kbuild: modules_install regression ? - depmod
From: Jon Masters <jonathan@jonmasters.org>
To: devzero@web.de
Cc: jcm@jonmasters.org, Jan Engelhardt <jengelh@computergmbh.de>, dl9pf@gmx.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <75140323@web.de>
References: <75140323@web.de>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 29 Dec 2007 08:46:01 -0500
Message-Id: <1198935961.9453.20.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-29 at 14:30 +0100, devzero@web.de wrote:

> > Though I'd say depmod should ignore the debug sections.
> 
> so depmod is acting sort of "stupid" here ?

depmod has a bunch of issues that need taking care of, this is just one
of them, but yeah, for now it should just ignore these additional sects.
I'd rewrite the thing but I need some more time to do that in the new
year (and there's lots of special casing for cross-building for
32/64/little/big endian that would need a lot of testing).

I'll push a new release over the weekend.

Jon.


