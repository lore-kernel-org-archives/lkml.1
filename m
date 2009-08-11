Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZHKPfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZHKPfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:35:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZHKPfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:35:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54098 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbZHKPfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:35:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Scholz <scholz@fias.uni-frankfurt.de>
Subject: Re: [Bug #13407] adb trackpad disappears after suspend to ram
Date: Tue, 11 Aug 2009 17:35:49 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
References: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera> <pRuaDVjxFBG.A.ZuF.QF2fKB@chimera> <87ab261lfy.fsf@scholz.fias.uni-frankfurt.de>
In-Reply-To: <87ab261lfy.fsf@scholz.fias.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908111735.49832.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 August 2009, Jan Scholz wrote:
> Hi,
> 
> The bug is still present in v2.6.31-rc5, it is fixed by commenting out
> {suspend,resume}_device_irqs() in drivers/base/power/main.c as suggested
> by Rafael.
> Recently I find the info
> "Platform driver 'snd_powermac' needs updating - please use dev_pm_ops"
> in dmesg, could this be related?

No, it's totally unrelated.

Best,
Rafael
