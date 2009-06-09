Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbZFITUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbZFITUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbZFITUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:20:23 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42137 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbZFITUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:20:23 -0400
Date: Tue, 9 Jun 2009 21:22:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Petr Tesarik <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
Message-ID: <20090609192239.GF7181@uranus.ravnborg.org>
References: <1243865115.24278.8.camel@nathan.suse.cz> <1244215559.1604.12.camel@nathan.suse.cz> <20090605200701.GB23195@uranus.ravnborg.org> <1244532418.5199.24.camel@nathan.suse.cz> <20090609181157.GA7181@uranus.ravnborg.org> <4A2EA719.2000608@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2EA719.2000608@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 11:16:57AM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >>
> >>> Why do we need *(.data .data.*) rather than *(.data*)?
> >>> *(.dynbss*)?
> >> I don't have any strong opinion here, but the former is exactly what the
> >> default linker script has.
> > 
> > My general take on this is that we should know and deal with what the linker produces.
> > So if we only expect .data then .data.* could go into .broken so we catch it. 
> > 
> 
> That will break if we change to per-function sections.

But adding it to .broken would catch this at first build which would
have told us so.
We shall try to make it -ffunction-sections compatible in first try though.

	Sam
