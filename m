Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYL2In7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYL2In7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 03:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYL2Inv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 03:43:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:42300 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbYL2Inu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 03:43:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=w9ovDhfLeEkkz2Ak6rzCirXoLP9bGzZCOzMSeHGUlk1Ef3e2IMdl6VeD5Z9HMKgj9Y
         jf7ykD4tDsMQIzvWcUkMWqUeUH/VMJM9BN1mqinodGoiYTCwMYEcHRdbbkQJD+eiNAEl
         WWsTQGhH8uawFuvTQkNDcYkVG1LAFfPM181TM=
Date: Mon, 29 Dec 2008 11:48:51 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, mj@ucw.cz
Subject: Re: [PATCH] move arch/x86/pci/pci.h to
	arch/x86/include/asm/pci_x86.h
Message-ID: <20081229084851.GA12756@x200.localdomain>
References: <1230382948.3373.1.camel@jaswinder.satnam> <20081229065713.GA10960@x200.localdomain> <1230537538.3090.4.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1230537538.3090.4.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 01:28:58PM +0530, Jaswinder Singh Rajput wrote:
> On Mon, 2008-12-29 at 09:57 +0300, Alexey Dobriyan wrote:
> > On Sat, Dec 27, 2008 at 06:32:28PM +0530, Jaswinder Singh Rajput wrote:
> > > Impact: cleanup, arch/x86/pci/pci.h -> arch/x86/include/asm/pci_x86.h
> > 
> > And this is done for what?
> 
> Don't you think ﻿arch/x86/pci/pci.h looks ugly it should be in
> arch/x86/incluse/asm directory ?

It was

	#include "../pci/pci.h"

which can look ugly, not full path.

Anyway, you want to put you question into changelog?

> It was suggested by Ingo :
> http://marc.info/?l=linux-kernel&m=123037395221921&w=2
> 
> I think Ingo will have more valid reasons to satisfy your curiousity ;-)

So you don't actually have an opinion? Why are you sending patch then?

	> could you send another patch that moves arch/x86/pci/pci.h to 
	> arch/x86/include/asm/pci_x86.h
	       ^^^		   ^^^
Or should it be arch/x86/include/asm/pci.h ?
