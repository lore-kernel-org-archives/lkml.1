Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbZHAJs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbZHAJs0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 05:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZHAJsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 05:48:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46789 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZHAJsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 05:48:25 -0400
Date: Sat, 1 Aug 2009 10:48:19 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20090801094818.GB7979@sirena.org.uk>
References: <1249057189-11992-1-git-send-email-quadros.roger@gmail.com>
 <20090731172002.GA32578@rakim.wolfsonmicro.main>
 <74d0deb30907311038w1b6cdd23iec3cfb2175fdedd0@mail.gmail.com>
 <b90c0690907311332o958b7f4nd025aa7a8b273a88@mail.gmail.com>
 <20090731214401.GC6335@sirena.org.uk>
 <b90c0690907312257u7a2677f0ne20d85ebaabc3935@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b90c0690907312257u7a2677f0ne20d85ebaabc3935@mail.gmail.com>
X-Cookie: VMS must die!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: Add GPIO enable control to fixed voltage
 regulator driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 01, 2009 at 08:57:43AM +0300, Roger Quadros wrote:

> Do we need to check whether CONFIG_GPIOLIB is available? or do we need
> to explicitly
> select it in Kconfig?

Check but I think that all the APIs you are using are stubbed out if
gpiolib is not available so you can just ignore it.  If not then ifdefs
around the code are the way forward.
