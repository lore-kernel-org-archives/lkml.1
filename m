Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYLCHlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYLCHlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYLCHlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:41:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44701 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbYLCHlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:41:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Wed, 3 Dec 2008 08:40:24 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812030222.28551.rjw@sisk.pl> <alpine.LFD.2.00.0812021751450.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812021751450.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812030840.25539.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 3 of December 2008, Linus Torvalds wrote:
> 
> On Wed, 3 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > Here's the output of 'lspci -vvxxx':
> 
> Ok, I'm not finding any documented quirks that would be memory regions, 
> and in fact it doesn't look like there is even any remotely likely 32-bit 
> valies that might be pointers in your PCI config space that look remotely 
> like they might be conflicting in the area of MMIO space that we allocate 
> PCI resources from (ie 0x88000000-0x92000000).
> 
> Of course, any odd MMIO regions might be descibed by some insane model 
> that doesn't look like an aligned 32-bit value, but that's unlikely.
> 
> So I'm still not seeing anything wrong in there.
> 
> > I'll run the 'pci=cbmemsize=4M' test tomorrow (need to have some sleep).
> 
> Sure. It will be interesting to see if it makes any difference.

It didn't help (failure in the 4th consecutive hibernation/resume cycle).

The patched kernel still hibernates and resumes without problems.

Thanks,
Rafael
