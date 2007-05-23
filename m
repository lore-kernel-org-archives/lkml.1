Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbXEWWSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbXEWWSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbXEWWSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:18:34 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756374AbXEWWSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:18:33 -0400
Date: Wed, 23 May 2007 15:16:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Robert Hancock <hancockr@shaw.ca>, Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-Reply-To: <200705231506.36229.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.0.98.0705231514410.3890@woody.linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <200705231403.24439.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.98.0705231444200.3890@woody.linux-foundation.org>
 <200705231506.36229.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 May 2007, Jesse Barnes wrote:
> >
> > How are those boards going to set up mmconfig? The whole standard is
> > broken, since there is no way to set it up.
> >
> > Trust the firmware? What a piece of crap!
> 
> What do you mean?  You set it up the normal way, by poking at config 
> space to see what's there

HOW DO YOU GET TO THE CONFIG SPACE IN THE FIRST PLACE?

The reason mmconfig is *BROKEN*CRAP* is that you cannot bootstrap it. 
There's no standard way to even figure out WHERE IT IS!

So we depend on firmware tables that are known to be broken!

That crap should be seen for the crap it is! Dammit, how hard can it be to 
just admit that mmconfig isn't that great?

		Linus
