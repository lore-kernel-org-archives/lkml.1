Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbXFNMIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbXFNMIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbXFNMH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:07:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbXFNMH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:07:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Seyfried <seife@suse.de>
Subject: Re: [PATCH, 2nd try] make disable_console_suspend runtime configurable
Date: Thu, 14 Jun 2007 14:14:21 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Frank Seidel <fseidel@suse.de>, akpm@linux-foundation.org,
       nigel@nigel.suspend2.net
References: <20070613200303.GB11437@suse.de> <20070613220800.GD2611@elf.ucw.cz> <20070613222308.GA17266@suse.de>
In-Reply-To: <20070613222308.GA17266@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141414.22152.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 14 June 2007 00:23, Stefan Seyfried wrote:
> On Thu, Jun 14, 2007 at 12:08:00AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > I hate having to recompile the kernel, just to be able to debug suspend.
> > > Remove CONFIG_DISABLE_CONSOLE_SUSPEND, replace it by a tunable in
> > > /sys/power/disable_console_suspend.
> > 
> > > Signed-off-by: Stefan Seyfried <seife@suse.de>
> > > Signed-off-by: Frank Seidel <fseidel@suse.de>
> > 
> > I wonder if there's a better name?
> 
> Suggest one.

Hmm, you could call it 'console_suspend' with
'echo disabled > /sys/power/console_suspend' for switching that off
(and analogously with 'enabled') and with 'cat /sys/power/console_suspend'
printing the current status.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
