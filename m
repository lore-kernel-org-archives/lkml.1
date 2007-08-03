Return-Path: <linux-kernel-owner+w=401wt.eu-S1763127AbXHCUq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763127AbXHCUq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbXHCUqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:46:17 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:33992 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbXHCUqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:46:17 -0400
Message-ID: <46B39416.7040809@web.de>
Date: Fri, 03 Aug 2007 22:46:14 +0200
From: =?ISO-8859-1?Q?Philipp_T=F6lke?= <philipptoelke@web.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Christophe Saout <christophe@saout.de>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: PROBLEM: Oops when using dm-crypt with dpt_i2o
References: <46B0D4B4.2040809@web.de> <20070803110430.88a4b543.akpm@linux-foundation.org>
In-Reply-To: <20070803110430.88a4b543.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/LceY8az+r7YZLy096+pPMZ5xOoKEnQ3EEOaca
	L3wjH2No0UQSKi+WvAlVvkHlrn94n9z5tv4qAnYzvgaHYLrJnc
	luatvkX7ApgOx8KLtZ3g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, hi everybody!

Thanks for the reply!

Andrew Morton wrote:
>> The oopses:
>>
>> #v+
>> BUG: unable to handle kernel paging request at virtual address 14001000
>> [...]
> 
> So it looks like q->request_fn points at 0x14001000, which is in outer
> space.
> 
> I wonder how that could happen, in the middle of heavy IO operations. 
> Possibly a memory scribble.  I'd suggest you enable CONFIG_SLAB,
> CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC.

That doesn't change anything, apart from adding a line "DEBUG_PAGEALLOC"
to the oopses. Do I have to enable the debugging manually? After a quick
grep over the sources and a google-session I think not but I'm no
kernel-hacker.

> You could also try switching
> from CONFIG_SLAB to CONFIG_SLUB, then enable CONFIG_SLUB_DEBUG.

Unfortunately the only change seems to be, that the Keyboard-Leds don't
flash after the crash. Everything else is the same.

Could a hardware-error cause this?

Thanks again,
-- 
Philipp Tölke
