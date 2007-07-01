Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbXGAPnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbXGAPnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 11:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXGAPnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 11:43:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59375 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbXGAPm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 11:42:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       chrisw@sous-sol.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: 2.6.22-rc6-mm1: Xen: WARNING: Absolute relocations present
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070628204001.GA6087@stusta.de> <46841EC4.7080805@goop.org>
Date: Sun, 01 Jul 2007 09:37:46 -0600
In-Reply-To: <46841EC4.7080805@goop.org> (Jeremy Fitzhardinge's message of
	"Thu, 28 Jun 2007 16:49:08 -0400")
Message-ID: <m1hcoorv79.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Adrian Bunk wrote:
>> <--  snip  -->
>>
>> ...
>>   RELOCS  arch/i386/boot/compressed/vmlinux.relocs
>> WARNING: Absolute relocations present
>> Offset     Info     Type     Sym.Value Sym.Name
>> c0101f80 020c6501   R_386_32 00000000  xen_irq_disable_direct_reloc
>> c0101f9a 0221ea01   R_386_32 00000000  xen_save_fl_direct_reloc
>> ...
>>
>> <--  snip  -->
>>
>
> Hm.  Those are false alarms.  I guess I could do something to hide them, but
> there's nothing inherently wrong with correctly used abs symbols.  Is there
> someway to whitelist them?

Yes.  Just add them to arch/i386/boot/compressed/relocs.c safe_abs_syms.

Eric
