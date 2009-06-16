Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZFPKMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZFPKMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZFPKMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:12:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZFPKMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:12:00 -0400
Subject: Re: [PATCH v2 0/8] clean up vdso-layout.lds.S
From: Petr Tesarik <ptesarik@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
In-Reply-To: <20090612180626.GB18203@uranus.ravnborg.org>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
	 <20090612180626.GB18203@uranus.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Tue, 16 Jun 2009 12:12:02 +0200
Message-Id: <1245147122.17481.205.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg píše v Pá 12. 06. 2009 v 20:06 +0200:
> On Fri, Jun 12, 2009 at 03:40:32PM +0200, Petr Tesarik wrote:
> > The handling of various sections in the VDSO linker script
> > looks pretty haphazard. This patch series cleans it up in
> > these regards:
> > 
> >  - improve the coding style
> >  - remove superfluous sections
> >  - issue a linker error if a section is encountered which
> >    is known not to work
> >  - check that the .got section is empty, except for the
> >    three entries defined by the ABI
> >  - discard sections which are not useful to user-space
> > 
> > Petr Tesarik (8):
> >   x86: Adjust the coding style of vdso-layout.lds.S
> >   x86: Remove .sdata from the vDSO linker script
> >   x86: add .broken section to the vDSO linker script
> >   x86: mark altinstr-related sections in vDSO as broken
> >   x86: mark some standard sections as broken in a vDSO
> >   x86: check the size of GOT in vDSO
> >   x86: remove unneeded section from the vDSO
> The above looks good.
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

What shall I do? Since Roland has some good ideas for improvement,
should I post a new patch series (v3), or should I add on top of the
acked one?

Petr Tesarik


