Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbZFIIKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbZFIIKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZFIIJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:09:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbZFIIJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:09:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
X-Fcc: ~/Mail/linus
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
In-Reply-To: Petr Tesarik's message of  Tuesday, 9 June 2009 09:57:37 +0200 <1244534257.5199.31.camel@nathan.suse.cz>
References: <1243865115.24278.8.camel@nathan.suse.cz>
	<1244215559.1604.12.camel@nathan.suse.cz>
	<20090605200701.GB23195@uranus.ravnborg.org>
	<1244532418.5199.24.camel@nathan.suse.cz>
	<20090609075247.DA95CFC3B2@magilla.sf.frob.com>
	<1244534257.5199.31.camel@nathan.suse.cz>
X-Zippy-Says: How do I get HOME?
Message-Id: <20090609080933.E68BEFC3B2@magilla.sf.frob.com>
Date: Tue,  9 Jun 2009 01:09:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which version of binutils are you using? I'm using binutils-2.19, and
> all empty sections get completely discarded, i.e. they do not affect the
> size of the output in any way.

Oh, empty, sure.  So then what is ".broken" for at all?
I thought this was for the nonempty-but-useless ones like .got et al
that the linker will insist on creating but we don't really need in the vDSO.


Thanks,
Roland
