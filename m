Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYHVLLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYHVLLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 07:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbYHVLLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 07:11:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:53173 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYHVLLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 07:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=cQV427RGYFqS+3O26aGKTenH7mIrnDo9qNq/b3TEhMo0gGH5LPK2RQ1To8cdulGrfI
         aQfA8ieKSgPyKA4lwPuvO51gISd/7vRkIfj6qttleQT3q8RuOd2hzzjsvIfpeXeLG7nU
         A6STeTTEOCoN6q4JGJAEEGH8fBdVJ8eKJwRdY=
Date: Fri, 22 Aug 2008 15:13:01 +0400
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Dave Jones <davej@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123	send_IPI_mask_bitmask+0xc3/0xe0()
Message-ID: <20080822111301.GA2321@x200.localdomain>
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com> <20080820013930.GN9807@one.firstfloor.org> <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org> <20080822022841.GG23334@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822022841.GG23334@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: adobriyan@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 04:28:41AM +0200, Andi Kleen wrote:
> > You may want to see if this patch fixes the problem; it does *NOT* have 
> > the correct error behaviour (some of the intervening layers don't 
> > propagate errors), but it should make the fault go away.
> 
> The alternative would be to just take out those msr_on_cpu() 
> interfaces again. Right now they are useless in the kernel,
> but still cause problems.
> 
> They were only added for OpenVZ's vCPUs which they back then
> promised me would hit mainline soon.

There were no such promises made. Reread thread.

> But that was some time  ago and there wasn't much progress on this.

