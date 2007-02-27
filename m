Return-Path: <linux-kernel-owner+w=401wt.eu-S1751671AbXB0Sso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbXB0Sso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 13:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXB0Sso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 13:48:44 -0500
Received: from gw.goop.org ([64.81.55.164]:45679 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbXB0Ssn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 13:48:43 -0500
Message-ID: <45E47D08.5020802@goop.org>
Date: Tue, 27 Feb 2007 10:48:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-arch@vger.kernel.org
Subject: Re: [patch 09/26] Xen-paravirt_ops: remove HAVE_ARCH_MM_LIFETIME,
 define no-op architecture implementations
References: <20070227081337.434798469@goop.org>	 <20070227081632.356636957@goop.org>	 <1172589358.3408.2.camel@mulgrave.il.steeleye.com>	 <45E46889.9090801@goop.org>	 <1172597726.3408.25.camel@mulgrave.il.steeleye.com>	 <45E470D6.7050401@goop.org> <1172599480.3408.28.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1172599480.3408.28.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Yes ... I forgot about that ... we'd need an asm/mmu_context_paravirt.h
> on every arch.
>   

Yep.  And I'm not too keen on that name; one could imagine other uses
for those hooks, even if they're being used for x86 paravirtualization
in this instance.

> I suppose this is just me being lazy ... I'm currently doing a bit of a
> rewrite in asm-parisc/mmu_context.h and I didn't want a massive merge
> conflict.
>   

Well, I'm happy to create asm-generic/mm_hooks.h or something, and
reduce all the changes to asm-*/mmu_context.h to a one-liner.

    J
