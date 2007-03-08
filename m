Return-Path: <linux-kernel-owner+w=401wt.eu-S1030574AbXCHVnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574AbXCHVnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030641AbXCHVnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:43:35 -0500
Received: from mail.suse.de ([195.135.220.2]:54570 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030574AbXCHVnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:43:35 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: hardwired VMI crap
Date: Thu, 8 Mar 2007 22:43:31 +0100
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       tglx@linutronix.de, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>,
       Daniel Arai <arai@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <45EF175D.6030609@vmware.com> <45F07D07.5090003@goop.org> <20070308213458.GA24634@elte.hu>
In-Reply-To: <20070308213458.GA24634@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703082243.31659.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> what we do _NOT_ want is some mixture of 'simplified' and 'hardwired' 
> native hardware access mixed with hypercalls that somehow ends up 
> creating a Frankenstein mixture of 'virtual silicon', is specified 
> nowhere else but in VMWare's proprietary hypervisor source code that we 
> have no way to fix and no way to even see!

Hmm, but we already drive the "vmware silicon" quite successfully with
fully virtualized kernels. And apparently the VMI version is the same,
just with some short cuts. Are you just worried about the ->apic_write()
hooks or about something else too?

-Andi
