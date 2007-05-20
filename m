Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbXETRRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbXETRRo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXETRRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:17:37 -0400
Received: from [216.16.235.2] ([216.16.235.2]:48057 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXETRRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:17:36 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 20 May 2007 13:15:54 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: David Rientjes <rientjes@google.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Extract common MODULE_INFO content into new moduleinfo.h.
In-Reply-To: <alpine.DEB.0.99.0705200934580.30819@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705201314590.22771@localhost.localdomain>
References: <Pine.LNX.4.64.0705200354380.3319@localhost.localdomain>
 <alpine.DEB.0.99.0705200142080.25601@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705200627220.6765@localhost.localdomain>
 <alpine.DEB.0.99.0705200934580.30819@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, David Rientjes wrote:

> On Sun, 20 May 2007, Robert P. J. Day wrote:
>
> > i can do that as long as there's no way that those changes can
> > (even theoretically) make a difference in the build.  in order to
> > make sure this patch didn't break anything, i went with a straight
> > cut-and-paste of the content to go into the new moduleinfo.h.
>
> __attribute_used__ is pointless outside of function definitions so
> the way it is currently written is incorrect.
>
> > so while i agree that those changes shouldn't hurt, personally,
> > i'd prefer to just put this patch through as is and come back
> > later to do any tidying related to attribute rewording.
>
> __attribute_used__ is deprecated so it would be helpful to change it
> now instead of requiring a second patch.  It's better if new patches
> no longer use a deprecated attribute.

fair enough.  i'll submit a revised patch shortly.

rday

p.s.  um ... just off-hand, i'm hoping that people understand the
rationale behind this patch.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
