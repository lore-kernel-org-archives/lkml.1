Return-Path: <linux-kernel-owner+w=401wt.eu-S933745AbZJFX2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745AbZJFX2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933621AbZJFX2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:28:30 -0400
Received: from ozlabs.org ([203.10.76.45]:54316 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933340AbZJFX23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:28:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Subject: Re: [PATCH v7] RO/NX protection for loadable kernel modules
Date: Tue, 6 Oct 2009 20:47:09 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Dave Jones <davej@redhat.com>
References: <817ecb6f0910050450o29ee65a1j49c27cf350b77493@mail.gmail.com>
In-Reply-To: <817ecb6f0910050450o29ee65a1j49c27cf350b77493@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910062047.10901.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009 10:20:42 pm Siarhei Liakh wrote:
> This patch is a logical extension of the protection provided by
> CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
> module_core and module_init into three logical parts each and setting
> appropriate page access permissions for each individual section:

Thanks, applied!

It will be in linux-next soon, and if all goes well, 2.6.33.

Cheers,
Rusty.
