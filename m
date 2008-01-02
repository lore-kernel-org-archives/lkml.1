Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYABCd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYABCd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYABCdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:33:17 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:39794 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYABCdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:33:16 -0500
Subject: Re: [PATCH 1/3] ide: use MODULE_VERSION()
From: Jon Masters <jonathan@jonmasters.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801011933.43930.bzolnier@gmail.com>
References: <200801011840.38757.bzolnier@gmail.com>
	 <20080101175333.GA27566@does.not.exist>
	 <200801011933.43930.bzolnier@gmail.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 01 Jan 2008 21:32:36 -0500
Message-Id: <1199241156.3300.55.camel@perihelion>
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

On Tue, 2008-01-01 at 19:33 +0100, Bartlomiej Zolnierkiewicz wrote:

> On the second thought: maybe we will be better off with limiting
> MODULE_VERSION() to the device drivers and the IDE core module for now,
> and just removing all these private version numbers from host drivers
> (with one or two exceptions they are not printed or exported currently,
> moreover exceptions are the cases like stale version numbers from 199x)?

Things like checkpatch could help advise people to bump the version
number, but it's a bit iffy. Matt D. actually uses the special source
version modinfo for DKMS - which is different - but it makes me wonder
whether dynamically generating a version based on source SHA1 wouldn't
be a better idea in most cases than an outdated hard-coded one.

Comments?

Jon.


