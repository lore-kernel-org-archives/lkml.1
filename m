Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbZIVPuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbZIVPuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZIVPuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:50:21 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:52299 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbZIVPuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r6cYw17kWD32MkwF3T2eHn078s9hyvttPY1hqbS3e9EMCosV8Y7NBfbaGdAIaUELuB
         GhP+U53IQ2iEZwDf9uA2PEbEu/pUXcitzBdLraBmKV5bAfhEElzDgPeC+ItzgGR1sVds
         82gW2uga+7NdfeUB4IZEeKmp0C6EpPobJA85k=
MIME-Version: 1.0
In-Reply-To: <200909220929.32301.rusty@rustcorp.com.au>
References: <817ecb6f0909101950v2fc6dc6u5cbc40cd9a9dde77@mail.gmail.com>
	 <200909220929.32301.rusty@rustcorp.com.au>
Date: Tue, 22 Sep 2009 11:50:21 -0400
Message-ID: <817ecb6f0909220850m4127b382h12fafd1e6182a292@mail.gmail.com>
Subject: Re: [PATCH v6] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is usually considered a bad idea.  Make a new config option,
> CONFIG_HAVE_SET_MEMORY_PROTECTION, select it in arch/x86/Kconfig.
> Then wrap the entire functions in one #ifdef CONFIG_HAVE_....
> and put empty versions in the #else.

Ok, will do.
