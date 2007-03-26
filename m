Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbXCZSsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbXCZSsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbXCZSsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:48:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35115 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752974AbXCZSsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:48:53 -0400
Date: Mon, 26 Mar 2007 20:48:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Marcus Better <marcus@better.se>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, pavel@suse.cz,
       linux-pm@lists.osdl.org
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070326184857.GD16477@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703261200.25587.marcus@better.se> <20070326143433.GC16477@stusta.de> <200703261942.52126.marcus@better.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200703261942.52126.marcus@better.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 07:42:51PM +0200, Marcus Better wrote:
> Adrian Bunk wrote:
> > > > Subject    : ThinkPad R60: suspend to disk broken
> 
> > Does setting CONFIG_PCI_MSI=n make any difference?
> 
> Yes, it does. The hanging resume problem went away. 

Thanks for testing.

If you enable it again, does the patch from [1] also fix it?

> (The display corruption and the instant resume were not affected.)

Not a surprise - it's currently quite common that people run into 
several distinct suspend regressions...

> Marcus

cu
Adrian

[1] http://lkml.org/lkml/2007/3/24/136 [2]
[2] x86_64 uses arch/i386/pci/common.c

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

