Return-Path: <linux-kernel-owner+w=401wt.eu-S1763479AbXKUAQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763479AbXKUAQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758361AbXKUAQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:16:33 -0500
Received: from ns1.suse.de ([195.135.220.2]:51179 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbXKUAQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:16:32 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH 15/18] x86 vDSO: consolidate vdso32
Date: Wed, 21 Nov 2007 01:15:10 +0100
User-Agent: KMail/1.9.6
Cc: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20071119215944.01B7C26F8BE@magilla.localdomain> <20071119220644.F41CA26F8C1@magilla.localdomain> <1195604010.6352.237.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1195604010.6352.237.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711210115.10446.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I think you should drop CONFIG_COMPAT_VDSO support for 32-bit VDSO on
> 64-bit kernel.  This was only to hack around a broken version of glibc
> that shipped with SUSE PRO 9.0, 

I would be severly opposed to that. You cannot break compatibility to a large
chunk of userland. You would also break some of my test setups.
 
> Perhaps it is finally time to remove the hack from 32-bit as well, and
> eliminate COMPAT_VDSO entirely?  Or does it really have to live forever.

Yes it has.

-Andi
 
