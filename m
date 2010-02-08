Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab0BHB3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 20:29:52 -0500
Received: from ozlabs.org ([203.10.76.45]:39154 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab0BHB3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 20:29:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH V10] RO/NX protection for loadable kernel modules
Date: Mon, 8 Feb 2010 11:59:44 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
References: <817ecb6f1002011539g3f30416fi60c7c5222cab8f3@mail.gmail.com> <201002021429.38331.rusty@rustcorp.com.au> <4B67C0F9.2020202@zytor.com>
In-Reply-To: <4B67C0F9.2020202@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002081159.45219.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010 04:36:49 pm H. Peter Anvin wrote:
> On 02/01/2010 07:59 PM, Rusty Russell wrote:
> > On Tue, 2 Feb 2010 10:09:53 am Siarhei Liakh wrote:
> >> This patch is a logical extension of the protection provided by
> >> CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
> >> module_core and module_init into three logical parts each and setting
> >> appropriate page access permissions for each individual section:
> >>
> >>   1. Code: RO+X
> >>   2. RO data: RO+NX
> >>   3. RW data: RW+NX
> >
> > Thanks, applied!
> 
> I also applied this to the -tip tree... do you prefer to carry it or 
> should I leave it as is?

I'm always happy for you to do my work for me!  There are no other module
patches likely to conflict.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
