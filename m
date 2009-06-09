Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbZFII3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbZFII3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZFII3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:29:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:52128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758301AbZFII3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:29:09 -0400
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
From: Petr Tesarik <ptesarik@suse.cz>
To: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090609080933.E68BEFC3B2@magilla.sf.frob.com>
References: <1243865115.24278.8.camel@nathan.suse.cz>
	 <1244215559.1604.12.camel@nathan.suse.cz>
	 <20090605200701.GB23195@uranus.ravnborg.org>
	 <1244532418.5199.24.camel@nathan.suse.cz>
	 <20090609075247.DA95CFC3B2@magilla.sf.frob.com>
	 <1244534257.5199.31.camel@nathan.suse.cz>
	 <20090609080933.E68BEFC3B2@magilla.sf.frob.com>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Tue, 09 Jun 2009 10:29:10 +0200
Message-Id: <1244536150.5199.33.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath píše v Út 09. 06. 2009 v 01:09 -0700:
> > Which version of binutils are you using? I'm using binutils-2.19, and
> > all empty sections get completely discarded, i.e. they do not affect the
> > size of the output in any way.
> 
> Oh, empty, sure.  So then what is ".broken" for at all?
> I thought this was for the nonempty-but-useless ones like .got et al
> that the linker will insist on creating but we don't really need in the vDSO.

No, that's for collecting sections which should never ever appear in a
vDSO. Or rather, when these sections do appear in a vDSO, I know for
sure that the resulting vDSO will not work properly.

Petr Tesarik


