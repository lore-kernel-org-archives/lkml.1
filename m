Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbYELPvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbYELPvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYELPvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:51:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:36255 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYELPvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:51:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=h9KI6MmC0bQEmEBva1hLGTt5Miwr9XQXVZWU9xFFXL/aN/b8eN98HDe5tjoiY3uEjPKDTf4czW7DkBbJVqAagPBi2506BOS2Nvb1Ivx1PfcAMY+IgcSIeh8D4qPPRVZbLJQ60irXXQNkoNYzg/CSObZbtnvxYDxN60Xtx0lBzdM=
Date: Mon, 12 May 2008 19:50:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms broken in 2.6.26-rc1-git6
Message-ID: <20080512155052.GB6913@cvg>
References: <20080509174148.GA22246@basil.nowhere.org> <482491D6.9030205@grupopie.com> <4824A7B6.70306@firstfloor.org> <4824AD3C.3070506@grupopie.com> <20080509233742.GA22265@martell.zuzino.mipt.ru> <48281540.9020207@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48281540.9020207@grupopie.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Paulo Marques - Mon, May 12, 2008 at 11:00:32AM +0100]
> Alexey Dobriyan wrote:
>> On Fri, May 09, 2008 at 08:59:56PM +0100, Paulo Marques wrote:
>>> Andi Kleen wrote:
>>>> [...]
>>>> Yes and? Surely that's not correct?
>>> That's not for me to judge, but I believe it has always been like that.
>> *cough*
>> Here is how typical /proc/kallsyms looks like:
>> ffffffff80200000 A _text
>> ffffffff80200000 T startup_64
>> ffffffff802000b7 t ident_complete
>> ffffffff80200100 T secondary_startup_64
>
> This isn't helpful... the question is whether it is kallsyms misbehaving 
> and placing new symbols in the kernel image or if it is some other change 
> in the kernel that is generating new symbols that end up in the symbol 
> table.
>
> My guess it is that it is the later, and in that case, from a kallsyms 
> standpoint "it has always been like that".
>
> -- 
> Paulo Marques - www.grupopie.com
>
>

If it help - I've taken Andi's config, compiled the kernel and
didn't find any screwed symbols (nor is System.map nor in /proc/kallsyms).
The kernel - today Linus's git tree:

---
commit 492c2e476eac010962850006c49df326919b284c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun May 11 17:09:41 2008 -0700

    Linux 2.6.26-rc2
---

The diff btw Andi's config and new one is:

+CONFIG_PCSPKR_PLATFORM=y
-CONFIG_PCNET32_NAPI=y

		- Cyrill -
