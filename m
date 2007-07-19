Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbXGSPk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbXGSPk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765975AbXGSPkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:40:18 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57205 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394AbXGSPkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:40:16 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 19 Jul 2007 11:32:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: does CONFIG_UNUSED_SYMBOLS have any value anymore?
In-Reply-To: <469F749F.8030606@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0707191131040.7047@localhost.localdomain>
References: <Pine.LNX.4.64.0707190849450.30763@localhost.localdomain>
 <469F749F.8030606@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Stefan Richter wrote:

> Robert P. J. Day wrote:
> ...
> > it's not clear if that means that it was a *one-time* transition
> > aid which is now unnecessary, or whether it's an *ongoing* aid which
> > might be used at any time.  currently, there are no invocations of
> > EXPORT_UNUSED_SYMBOL[_GPL] anywhere in the tree.  so does that mean
> > this feature can be tossed?  or might it still be used every so often?
>
> git-blame (or qgit, which I actually used) points from this part of
> lib/Kconfig.debug to the following chunk in
> Documentation/feature-removal-schedule.txt:
>
> What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
> 	(temporary transition config option provided until then)
> 	The transition config option will also be removed at the same time.
> When:	before 2.6.19
> Why:	Unused symbols are both increasing the size of the kernel binary
> 	and are often a sign of "wrong API"
> Who:	Arjan van de Ven <arjan@linux.intel.com>

argh.  i should have checked there first.  sorry for the noise.  i can
patch that baby out unless arjan wants to do it.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
