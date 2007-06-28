Return-Path: <linux-kernel-owner+w=401wt.eu-S1765644AbXF1UuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765644AbXF1UuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbXF1UuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:50:09 -0400
Received: from gw.goop.org ([64.81.55.164]:47077 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760123AbXF1UuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:50:08 -0400
Message-ID: <46841EC4.7080805@goop.org>
Date: Thu, 28 Jun 2007 16:49:08 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       chrisw@sous-sol.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1: Xen: WARNING: Absolute relocations present
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070628204001.GA6087@stusta.de>
In-Reply-To: <20070628204001.GA6087@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> <--  snip  -->
>
> ...
>   RELOCS  arch/i386/boot/compressed/vmlinux.relocs
> WARNING: Absolute relocations present
> Offset     Info     Type     Sym.Value Sym.Name
> c0101f80 020c6501   R_386_32 00000000  xen_irq_disable_direct_reloc
> c0101f9a 0221ea01   R_386_32 00000000  xen_save_fl_direct_reloc
> ...
>
> <--  snip  -->
>   

Hm.  Those are false alarms.  I guess I could do something to hide them, 
but there's nothing inherently wrong with correctly used abs symbols.  
Is there someway to whitelist them?

    J

