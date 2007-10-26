Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbXJZBzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbXJZBzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762381AbXJZBza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:55:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:21175 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762141AbXJZBz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W6W0HvASMTuW7hbT4tnzP/AjrNi+OgKtinnhbOj+ixtGBPvhpzIQHIAuZmlcyWisjuJa/K3JN71QdALSG5vbyLfuZDOfHFmmk67Jq4yoqa8lXgHZ71v4Q15beXhuqZQcHkyEiV4b748SWihdsXwDhJBvMcn+qSFH/XZm2izFixw=
Message-ID: <86802c440710251855m183aa7b1me02de7204dea22c2@mail.gmail.com>
Date: Thu, 25 Oct 2007 18:55:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/6] x86: unification of i386 and x86_64 Kconfig.debug
Cc: "Randy Dunlap" <rdunlap@xenotime.net>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
In-Reply-To: <47212C42.5010200@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071025195644.GA14501@uranus.ravnborg.org>
	 <20071025200434.GD14501@uranus.ravnborg.org>
	 <86802c440710251630j71b9f750j2e0fbe4c9b37165e@mail.gmail.com>
	 <20071025163541.ee081c26.rdunlap@xenotime.net>
	 <47212C42.5010200@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Randy Dunlap wrote:
> >
> > It doesn't do that.  EARLY_PRINTK for x86_64 lives in
> > arch/x86_64/Kconfig (i.e., a different file).
> >
> > Patches welcome.
> >
>
> I think Sam's patchset already takes care of that.

arch/x86_64/Kconfig.debug will be removed. in 5/6 patch.
and in the same patch arch/i386/Kconfig.debug will be
arch/x86/Kconfig.debug and it make EARLY_PRINTK depend on x86_32

YH
