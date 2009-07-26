Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZGZThs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZGZThs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 15:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZGZThr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 15:37:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57768 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbZGZThr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 15:37:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
Date: Sun, 26 Jul 2009 21:38:18 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Frans Pop <elendil@planet.nl>,
       Manuel Lauss <manuel.lauss@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Manuel Lauss <manuel.lauss@gmail.com>
References: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com> <200907252139.30674.rjw@sisk.pl> <20090726150834.GB27022@sirena.org.uk>
In-Reply-To: <20090726150834.GB27022@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907262138.18716.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 July 2009, Mark Brown wrote:
> On Sat, Jul 25, 2009 at 09:39:30PM +0200, Rafael J. Wysocki wrote:
> 
> > Yes, they would.  In general, you'd probably want to do something like this:
> 
> > static struct dev_pm_ops au1xmmc_pmops = {
> > 	.resume		= au1xmmc_resume,
> > 	.suspend		= au1xmmc_suspend,
> > 	.freeze		= au1xmmc_resume,
> > 	.thaw		= au1xmmc_suspend,
> 
> I'd have expected freeze and thaw to be the other way around here?

Sure, sorry.

.suspend() corresponds to .freeze() and .poweroff(), while .resume()
corresponds to .thaw() and .restore().

Best,
Rafael
