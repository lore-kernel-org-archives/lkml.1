Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbYHPUFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYHPUFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbYHPUFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:05:34 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:23992 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYHPUFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:05:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sLIB+onIeQeohhAU02ZBNt7/mnWUZUbPn2LYNY56rsybpZmEn2BvX5Kzr3SJ6n0Nue
         LeDn+f1GnJ61ehwYnHvX1j7CwcCdb91E4Hm/nxNGTKQfTGW+S9T0x9p3XOp/iG0iUVj6
         Ory8MUCJrt7N2Cg70tW02peWTmUcGGHauzMqo=
Date: Sun, 17 Aug 2008 00:05:43 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] x86: apic - unify lapic_resume
Message-ID: <20080816200543.GA7182@lenovo>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com> <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com> <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com> <Pine.LNX.4.55.0808162041190.17944@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0808162041190.17944@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sat, Aug 16, 2008 at 08:52:07PM +0100]
| On Sat, 16 Aug 2008, Cyrill Gorcunov wrote:
| 
| > +#ifdef CONFIG_X86_64
| > +	if (x2apic)
| > +		enable_x2apic();
| > +	else
| > +#endif
| 
|  Hmm, x86-64 hardware can run a 32-bit kernel, so it might be a good idea
| to take the opportunity of the merge and extend x2APIC support to the
| 32-bit configuration too.  It should be mostly a mechanical change.  Just
| a suggestion though -- feel free to ignore if you'd rather not dive into
| it. ;)
| 
|   Maciej
| 

yes, I thought about this - will take a look, thanks!

		- Cyrill -
