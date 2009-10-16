Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbZJPN2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbZJPN2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbZJPN2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:28:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbZJPN2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:28:35 -0400
Date: Fri, 16 Oct 2009 15:27:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH V6] x86: NX protection for kernel data
Message-ID: <20091016132730.GA5731@elte.hu>
References: <817ecb6f0910151625o7eb645e8pff574a2c12bdb763@mail.gmail.com> <20091016064433.GC20388@elte.hu> <817ecb6f0910160622m68486be7ifeb56b43921fc7c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <817ecb6f0910160622m68486be7ifeb56b43921fc7c1@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> > thanks - this one looks good now.
> >
> > Would be nice if you could send this with the patch that also deals 
> > with the first 1 MB.
> 
> I do plan to have that first megabyte fixed. But for now, let's keep 
> these patches separate, as there are many things that rely on that 1MB 
> area and I want to make sure they all still work properly with the 
> patch.

Well, if we are going to touch this area i'd like to see them addressed 
together.

The 1MB thing would obviously be a default-off Kconfig option so in that 
sense it should not break anything by default.

	Ingo
