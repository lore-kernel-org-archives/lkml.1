Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZIYLh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZIYLh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 07:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZIYLh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 07:37:57 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:16900 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbZIYLhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 07:37:53 -0400
X-Trace: 266405067/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.26.166/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.26.166
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAP5HvEpPRRqm/2dsb2JhbACBUdVxhBwF
X-IronPort-AV: E=Sophos;i="4.44,451,1249254000"; 
   d="scan'208";a="266405067"
Date: Fri, 25 Sep 2009 12:36:15 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nigel Cunningham <ncunningham@crca.org.au>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: No more bits in vm_area_struct's vm_flags.
In-Reply-To: <4ABC7FBC.4050409@crca.org.au>
Message-ID: <Pine.LNX.4.64.0909251225150.7496@sister.anvils>
References: <4AB9A0D6.1090004@crca.org.au> <Pine.LNX.4.64.0909232056020.3360@sister.anvils>
 <4ABC7FBC.4050409@crca.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009, Nigel Cunningham wrote:
> Hugh Dickins wrote:
> > 
> > Does TuxOnIce rely on CONFIG_MMU?  If so, then the TuxOnIce patch
> > could presumably reuse VM_MAPPED_COPY for now - but don't be
> > surprised if that's one we clean away later on.
> 
> Hmm. I'm not sure. The requirements are the same as for swsusp and
> uswsusp. Is there some tool to graph config dependencies?

If its requirements are the same as theirs, then I think yes,
TuxOnIce relies on  config MMU: because config HIBERNATION depends
on SWAP (kernel/power/Kconfig) and config SWAP depends on MMU
(init/Kconfig).

But I hesitated to assume that, because in the TuxOnIce patch I have
here for reference (e.g. when deciding it'll cause you unwelcome hassle
if I move swap_info_struct from swap.h to swapfile.c!), it looked as if
you support saving to an ordinary file, not just to a swap file?

> Is there some tool to graph config dependencies?

I don't know it, but would be nice, and maybe it does exist.

Hugh
