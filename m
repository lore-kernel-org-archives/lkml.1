Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYI1Wil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYI1Wil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 18:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYI1Wic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 18:38:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43223 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbYI1Wic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 18:38:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: sdhci: Loads of scary messages during suspend/resume with SD card inserted
Date: Mon, 29 Sep 2008 00:42:15 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx,
       linux-pm@lists.linux-foundation.org
References: <200809282146.57960.elendil@planet.nl> <200809282204.07696.elendil@planet.nl>
In-Reply-To: <200809282204.07696.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809290042.16529.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 28 of September 2008, Frans Pop wrote:
> On Sunday 28 September 2008, Frans Pop wrote:
> > Whilst playing with it, I found the following messages in my logs
> > during suspend. At the time the card was inserted, but nothing on it
> > was mounted.
> >
> > There also seems to be a problem while resuming, especially:
> > mmc mmc0:8879: parent mmc0 should not be sleeping
> > More context at the bottom of the mail.
> 
> Forgot the most important bits.
> 
> Kernel is current git (2.6.27-rc7-106-g6ef190c), x86_64.
> Laptop is running Debian amd64/unstable.

The 'parent mmc0 should not be sleeping' message is a known problem with MMC.

Thanks,
Rafael
