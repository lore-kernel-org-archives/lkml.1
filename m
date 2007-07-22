Return-Path: <linux-kernel-owner+w=401wt.eu-S1764962AbXGVJZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764962AbXGVJZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761956AbXGVJZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:25:10 -0400
Received: from ns1.suse.de ([195.135.220.2]:55380 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761683AbXGVJZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:25:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] x86_64 vDSO: install unstripped copies on disk
Date: Sun, 22 Jul 2007 11:24:59 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070722031312.681484D05C1@magilla.localdomain>
In-Reply-To: <20070722031312.681484D05C1@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707221124.59784.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 05:13:12 Roland McGrath wrote:
> This keeps an unstripped copy of the vDSO images built before they are
> stripped and embedded in the kernel.  The unstripped copies get installed
> in $(MODLIB)/vdso/ by "make install".  These files can be useful when they
> contain source-level debugging information.

Hmm, how would the debugger find them? There won't be any reference 
from the vdso to them.

If you do that then you should probably add a debuglink reference first.

-Andi
