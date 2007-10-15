Return-Path: <linux-kernel-owner+w=401wt.eu-S1764900AbXJONT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764900AbXJONT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760979AbXJONTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:19:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:25692 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759806AbXJONTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H8+UD+mZOpgp7GR2/XVsLFaBTzeU/uj46CXuymhGFshTdCoGglRCE5Vc7RdEf87aya1bIon1fJZoZY6ipXKA+h/Rs67n+0kYONifd/z2g8W8y86mns1DbV2rwIuW5EUyhuXlUIteZONIMnlLfCQLLKeL35jPq8IfQDGWbHcYqlw=
Message-ID: <d120d5000710150619l7d4c18f6jb51a59e5f5c12c43@mail.gmail.com>
Date: Mon, 15 Oct 2007 09:19:48 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [patch 2/8] m68k: Atari keyboard ACIA driver cleanup
Cc: "Andreas Schwab" <schwab@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       "Michael Schmitz" <schmitz@biophys.uni-duesseldorf.de>
In-Reply-To: <Pine.LNX.4.64.0710132027010.15951@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071013123123.085686856@mail.of.borg>
	 <20071013123412.672481897@mail.of.borg> <jed4vjrpwk.fsf@sykes.suse.de>
	 <Pine.LNX.4.64.0710132027010.15951@anakin>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sat, 13 Oct 2007, Andreas Schwab wrote:
> > Geert Uytterhoeven <geert@linux-m68k.org> writes:
> > > --- a/arch/m68k/atari/atakeyb.c
> > > +++ b/arch/m68k/atari/atakeyb.c
> > > @@ -1,5 +1,5 @@
> > >  /*
> > > - * linux/atari/atakeyb.c
> > > + * linux/arch/m68k/atari/atakeyb.c
> >
> > Please kill that line.
>
> Done. New version below:
>
> Subject: m68k: Atari keyboard ACIA driver cleanup
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@atrey.karlin.mff.cuni.cz
>
> m68k: Atari keyboard ACIA driver cleanup:
>  - removed dead key autorepeat code
>  - removed hardcoded initial keymap
>
> Signed-off-by: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Looks good, thank you Geert. I understand Linus will merge this...

-- 
Dmitry
