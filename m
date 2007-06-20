Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbXFTOhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbXFTOhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXFTOho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:37:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53481 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbXFTOhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:37:43 -0400
Date: Wed, 20 Jun 2007 16:37:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070620143740.GA17161@one.firstfloor.org>
References: <200706061229.24486.jesse.barnes@intel.com> <46790DFA.5090503@aitel.hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46790DFA.5090503@aitel.hist.no>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I assume this cannot be fixed by the simple approach
> of echoing some useful numbers into /proc/mtrr like
> we used to do for video memory? (Before X did this
> automatically?)
> 
> An extra bootscript seems better than loosing memory.

In some cases it probably can, in other cases not because the memory
controller is misconfigured or not the right bits are set 
in the PCI bridges to enable DAC IO or ... or ...

There are also definite limits on how much quirks can do 
to fix this -- Linux is a generic kernel, not a BIOS replacement,
and can never be as intimate with the current setup
as the BIOS is.

It's definitely far safer to not use the memory. You're 
running in a situation never tested or considered by the 
motherboard vendor and everything is possible.

-Andi

