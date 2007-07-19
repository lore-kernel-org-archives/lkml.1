Return-Path: <linux-kernel-owner+w=401wt.eu-S939440AbXGSPgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939440AbXGSPgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932094AbXGSPg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:36:28 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57036 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765899AbXGSPg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:36:27 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 19 Jul 2007 11:34:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: does CONFIG_UNUSED_SYMBOLS have any value anymore?
In-Reply-To: <469F7918.3000503@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0707191133100.7047@localhost.localdomain>
References: <Pine.LNX.4.64.0707190849450.30763@localhost.localdomain>
 <469F749F.8030606@s5r6.in-berlin.de> <469F7918.3000503@linux.intel.com>
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

On Thu, 19 Jul 2007, Arjan van de Ven wrote:

> Stefan Richter wrote:
> > Robert P. J. Day wrote:
> > ...
> > > it's not clear if that means that it was a *one-time* transition
> > > aid which is now unnecessary, or whether it's an *ongoing* aid which
> > > might be used at any time.  currently, there are no invocations of
> > > EXPORT_UNUSED_SYMBOL[_GPL] anywhere in the tree.  so does that mean
> > > this feature can be tossed?  or might it still be used every so often?
>
> it's one of those pieces of infrastructure that get used from time
> to time to phase out symbol exports... we should be more agressive
> about that; about 1/3rd of the exports is not used by anything in
> linux, yet each symbol costs about 100 bytes of memory at runtime.

ok, so maybe its removal file entry should be deleted if it's going to
hang around.  your call.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
