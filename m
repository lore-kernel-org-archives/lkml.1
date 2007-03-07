Return-Path: <linux-kernel-owner+w=401wt.eu-S965424AbXCGSfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424AbXCGSfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932287AbXCGSfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:35:33 -0500
Received: from gw.goop.org ([64.81.55.164]:53007 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771AbXCGSfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:35:32 -0500
Message-ID: <45EF05F0.7090700@goop.org>
Date: Wed, 07 Mar 2007 10:35:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <45EDD82F.90204@vmware.com> <1173225182.24738.507.camel@localhost.localdomain> <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com> <1173228544.24738.514.camel@localhost.localdomain> <45EE0D10.7070807@vmware.com> <1173230305.24738.529.camel@localhost.localdomain> <45EE1EA3.90803@vmware.com> <1173256666.24738.576.camel@localhost.localdomain> <45EEF966.6060902@goop.org> <20070307174957.GA31371@elte.hu>
In-Reply-To: <20070307174957.GA31371@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ugh. Please take it from me: i've watched the Linux time code walk its 
> long, rocky 10+ years road. One of the first mistakes was when we made 
> the TSC the center of the i386-time universe. (incidentally, it was me 
> who did the first steps of that, as a rookie kernel hacker) We got cured 
> out of that in v2.6.19, v2.6.20 and v2.6.21. Granted, Xen is only at the 
> beginning of that same road. Meet in another 10 years? ;)

Yep, the tsc has myriad problems; for Xen its the best of a bad lot. 
Unfortunately in 10 years no clearly better alternative has appeared;
maybe in 10 years there will be one.  It might even be the tsc.

    J
