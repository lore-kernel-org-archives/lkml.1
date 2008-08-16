Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYHPUMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYHPUMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYHPUM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:12:27 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:28165 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYHPUM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:12:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qzktk03joKnUlL2gprnQcIrOKyByUcrDNZ75YvcATlhB/1MisVr1yyjhvR8IYRQ3yp
         AGnUfECe4W8PcD/Fpcf8UP9EVNwA7R8kQ4DGSJEcCDIWQ+7tdOHnFlixvXQztaC3IJPO
         W9BTnTPEmcGLr8RdLm7dXM1uK+Et+E3cs4tQ4=
Date: Sun, 17 Aug 2008 00:12:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] x86: apic - unify lapic_resume
Message-ID: <20080816201235.GB7182@lenovo>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com> <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com> <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com> <Pine.LNX.4.55.0808162041190.17944@cliff.in.clinika.pl> <20080816130008.349b031d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080816130008.349b031d@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Arjan van de Ven - Sat, Aug 16, 2008 at 01:00:08PM -0700]
| On Sat, 16 Aug 2008 20:52:07 +0100 (BST)
| "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
| 
| > On Sat, 16 Aug 2008, Cyrill Gorcunov wrote:
| > 
| > > +#ifdef CONFIG_X86_64
| > > +	if (x2apic)
| > > +		enable_x2apic();
| > > +	else
| > > +#endif
| > 
| >  Hmm, x86-64 hardware can run a 32-bit kernel, so it might be a good
| > idea to take the opportunity of the merge and extend x2APIC support
| > to the 32-bit configuration too.  It should be mostly a mechanical
| > change.  Just a suggestion though -- feel free to ignore if you'd
| > rather not dive into it. ;)
| 
| it's not like you can/want to go over 128 cpus on a 32 bit kernel
| though..
| -- 
| If you want to reach me at my work email, use arjan@linux.intel.com
| For development, discussion and tips for power savings, 
| visit http://www.lesswatts.org
| 

Arjan,

it seems this limit is not APIC related since iirc 82489DX allows
to address 2^14 bits, x2APIC - more then 128 entities too. So I suspect
it somehow cpu bitmap related. Am I wrong (I didn't _check_ the code)?

		- Cyrill -
