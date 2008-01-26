Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYAZNjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYAZNjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 08:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYAZNjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 08:39:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:58326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYAZNjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 08:39:05 -0500
From: Stefan Roese <sr@denx.de>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH][ppc] logical/bitand typo in powerpc/boot/4xx.c
Date: Sat, 26 Jan 2008 14:37:33 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
References: <4797C1AD.3040307@tiscali.nl> <20080123191704.2d74073a@zod.rchland.ibm.com>
In-Reply-To: <20080123191704.2d74073a@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801261437.34338.sr@denx.de>
X-Provags-ID: V01U2FsdGVkX18VUcR/5DvnCBlohA5A2prb/Yb+oQPwE0Hutos
 BkQo8iRhUv/YChA2jCmDum8MiTSwhcH/jpP85nKPSpgSSf1m2P
 7SCn7utAarHXHa/yyLvddZYXn6O2Dtw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2008, Josh Boyer wrote:
> On Wed, 23 Jan 2008 23:37:33 +0100
>
> Roel Kluin <12o3l@tiscali.nl> wrote:
> > logical/bitand typo
> >
> > Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> > ---
> > diff --git a/arch/powerpc/boot/4xx.c b/arch/powerpc/boot/4xx.c
> > index ebf9e21..dcfb459 100644
> > --- a/arch/powerpc/boot/4xx.c
> > +++ b/arch/powerpc/boot/4xx.c
> > @@ -104,7 +104,7 @@ void ibm4xx_denali_fixup_memsize(void)
> >  	val = DDR_GET_VAL(val, DDR_CS_MAP, DDR_CS_MAP_SHIFT);
> >  	cs = 0;
> >  	while (val) {
> > -		if (val && 0x1)
> > +		if (val & 0x1)
> >  			cs++;
> >  		val = val >> 1;
> >  	}
>
> Hm, good catch.
>
> Stefan, have you had problems with this code at all?

I'm not using the bootwrapper on a 4xx with Denali core.

Best regards,
Stefan
