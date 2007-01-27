Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbXA0RTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbXA0RTB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 12:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXA0RTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 12:19:01 -0500
Received: from ns1.suse.de ([195.135.220.2]:41994 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbXA0RTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 12:19:01 -0500
Date: Sat, 27 Jan 2007 18:18:59 +0100
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org
Subject: Re: blacklist kernel boot option
Message-ID: <20070127171859.GB10879@strauss.suse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <200701270222.36060.mista.tapas@gmx.net> <Pine.LNX.4.61.0701271552090.22295@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0701271552090.22295@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jan Engelhardt <jengelh@linux01.gwdg.de> [2007-01-27 15:53]:
> 
> On Jan 27 2007 02:22, Florian Schmidt wrote:
> >
> >i was wondering whether there exists any mechanism to blacklist modules
> >from being loaded besides the typical etc/modprobe.d/blacklist type
> >mechanisms. Sometimes you have a module oopsing because of faulty hw
> >which cannot be removed rendering the system unbootable. And sometimes
> >there's just no way to edit the modprobe blacklist because you cannot
> >boot the box :) Basically i would like to setup a list of module names
> >the kernel simply refuses to load..
> >
> >blacklist=some_module,some_other_module,some_third_module
> 
> >Does something exist?
> 
> I think there was something like that although I can't remember
> either what it was.

brokenmodules=..., but that's SUSE's linuxrc.


Regards,
Bernhard
