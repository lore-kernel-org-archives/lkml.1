Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbZGZPIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbZGZPIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 11:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZGZPIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 11:08:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58837 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbZGZPIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 11:08:42 -0400
Date: Sun, 26 Jul 2009 16:08:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Frans Pop <elendil@planet.nl>,
       Manuel Lauss <manuel.lauss@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Manuel Lauss <manuel.lauss@gmail.com>
Message-ID: <20090726150834.GB27022@sirena.org.uk>
References: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com>
 <200907252019.01266.elendil@planet.nl>
 <20090725191037.GE14062@dtor-d630.eng.vmware.com>
 <200907252139.30674.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907252139.30674.rjw@sisk.pl>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 09:39:30PM +0200, Rafael J. Wysocki wrote:

> Yes, they would.  In general, you'd probably want to do something like this:

> static struct dev_pm_ops au1xmmc_pmops = {
> 	.resume		= au1xmmc_resume,
> 	.suspend		= au1xmmc_suspend,
> 	.freeze		= au1xmmc_resume,
> 	.thaw		= au1xmmc_suspend,

I'd have expected freeze and thaw to be the other way around here?
