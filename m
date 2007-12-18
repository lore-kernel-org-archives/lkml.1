Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbXLRLX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbXLRLX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 06:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbXLRLXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 06:23:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:48676 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752820AbXLRLXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:23:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KVjA14ABOiwiITtW0mJwR8RujyeS5muEkEJxoIq90rztbQe4xdtdP3y8p3zkgxXf+T4+7oYSwNvg5aeJysEHnnvyEX4xe0xiykb9/EffAe+UZ/Tmp7bleTCOwImuCFL0+9403MMp0HuQnUHeBRWGCeP5nrW6HarkhOhqA9MIcn4=
Subject: Re: [PATCH] x86: Use helper in fault_64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20071218111908.GD9002@elte.hu>
References: <1197975535.7734.21.camel@brick> <20071218111908.GD9002@elte.hu>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 03:23:49 -0800
Message-Id: <1197977029.7734.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-18 at 12:19 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Use the fixup_exception() helper in fault_64.c
> 
> thanks, applied.
> 
> > This is only appropriate if CONFIG_PNP_BIOS cannot be set on X86_64, 
> > which looks to be the case, but needs confirmation.
> 
> yeah, that seems to be the case:
> 
> in drivers/pnp/pnpbios/Kconfig:
> 
>  config PNPBIOS
>  ...
>          depends on ISA && X86 && EXPERIMENTAL
> 
> in arch/x86/Kconfig:
> 
>  if X86_32
>  config ISA

That's how I read it, just wanted a second opinion.

Harvey

