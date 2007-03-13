Return-Path: <linux-kernel-owner+w=401wt.eu-S1750952AbXCMTtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750952AbXCMTtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXCMTtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:49:05 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60550 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXCMTtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:49:04 -0400
Date: Tue, 13 Mar 2007 12:48:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux v2.6.21-rc3
In-Reply-To: <20070313194024.GA14847@suse.de>
Message-ID: <Pine.LNX.4.64.0703131246490.9690@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
 <m1zm6hq70n.fsf@ebiederm.dsl.xmission.com> <20070313194024.GA14847@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Mar 2007, Greg KH wrote:
> 
> > - pci_save_state, pci_restore_state are broken and have been for a
> >   while if used on anything besides plain pci (pci-x, pci-e and msi)
> >   and are not used in pairs. (gregkh and Andrew have the patches to 
> >   correct this).
> 
> I think these are already in Linus's tree right now, right?

Yes. I just wanted some more testing of it, and while I didn't hear much, 
at least Auke added his ack, and the old state was clearly broken, so they 
got applied yesterday.

		Linus
