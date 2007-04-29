Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbXD2MSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbXD2MSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbXD2MSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:18:04 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:48886 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbXD2MSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hchORaFHWZfWRUrVQruhoF9tcXhf4+kzwmT5mAZn4CJGN5e7pGlGOW/LGCy1tlwPxoxWuUIT9j4gzAcpdknQOrfVp8PFUNVpPx3MragArjMoyybtXuU8jagNEQBChYcyr187B/uQwD1s12MzP8zEWTUIZJo3IHsxkg4x1yK6II8=
Subject: Re: [PATCH] [37/48] i386: ignore vgacon if hardware not present
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070429105327.2ECA6151C5@wotan.suse.de>
References: <200704291252.514680000@suse.de>
	 <20070429105327.2ECA6151C5@wotan.suse.de>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 20:17:50 +0800
Message-Id: <1177849070.17715.0.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 12:53 +0200, Andi Kleen wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> On Thu, 2007-03-29 at 12:36 +0200, Andi Kleen wrote:
> > On Thu, Mar 29, 2007 at 05:46:48PM +1000, Rusty Russell wrote:
> > > (Did this fall through the cracks?  I don't see it in -mm.  It's
> > > standalone, and saves some silly code in lguest and presumably others).
> > 
> > Normally it should go to some some console maintainer? 
> 
> Hmm, but who?
> 
> > Ok I can add it.
> 
> Thanks.  While you're in a patch-applying mood, how about this?
> 
> Cheers,
> Rusty.
> ==
> Use X86_EFLAGS_IF in irqflags.h.
> 
> Move X86_EFLAGS_IF et al out to a new header: processor-flags.h, so we
> can include it from irqflags.h and use it in raw_irqs_disabled_flags().
> 
> As a side-effect, we could now use these flags in .S files.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  include/asm-i386/irqflags.h        |    3 ++-
>  include/asm-i386/processor-flags.h |   26 ++++++++++++++++++++++++++
>  include/asm-i386/processor.h       |   22 +---------------------
>  3 files changed, 29 insertions(+), 22 deletions(-)

The subject does not reflect the content of the patch :-). And I believe
ignore-vgacon-if-hardware-not-present is already in mainline.

Tony


