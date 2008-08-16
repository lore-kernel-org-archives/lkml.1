Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbYHPUAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbYHPUAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYHPUA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:00:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:40741 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYHPUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:00:26 -0400
Date: Sat, 16 Aug 2008 13:00:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] x86: apic - unify lapic_resume
Message-ID: <20080816130008.349b031d@infradead.org>
In-Reply-To: <Pine.LNX.4.55.0808162041190.17944@cliff.in.clinika.pl>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
	<f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
	<722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com>
	<Pine.LNX.4.55.0808162041190.17944@cliff.in.clinika.pl>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 20:52:07 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

> On Sat, 16 Aug 2008, Cyrill Gorcunov wrote:
> 
> > +#ifdef CONFIG_X86_64
> > +	if (x2apic)
> > +		enable_x2apic();
> > +	else
> > +#endif
> 
>  Hmm, x86-64 hardware can run a 32-bit kernel, so it might be a good
> idea to take the opportunity of the merge and extend x2APIC support
> to the 32-bit configuration too.  It should be mostly a mechanical
> change.  Just a suggestion though -- feel free to ignore if you'd
> rather not dive into it. ;)

it's not like you can/want to go over 128 cpus on a 32 bit kernel
though..
-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
