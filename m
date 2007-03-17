Return-Path: <linux-kernel-owner+w=401wt.eu-S932817AbXCQM1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbXCQM1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 08:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933691AbXCQM1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 08:27:49 -0400
Received: from ns2.suse.de ([195.135.220.15]:58568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932817AbXCQM1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 08:27:48 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Len Brown <lenb@kernel.org>, tglx@linutronix.de,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so far
References: <200703161230.03712.maximlevitsky@gmail.com>
	<1174088686.13341.347.camel@localhost.localdomain>
	<200703162132.53906.lenb@kernel.org>
	<1174127539.3538.207.camel@laptopd505.fenrus.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Mar 2007 14:26:57 +0100
In-Reply-To: <1174127539.3538.207.camel@laptopd505.fenrus.org>
Message-ID: <p73k5xg6lwe.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
> 
> well we can do the handshake to take ownership like we do much later in
> boot, but that requires PCI to be there and fully discovered, which we
> don't have this early.

That's not true - we do early pci discovery. Doing USB handsoff
there would be quite possible.

-Andi

