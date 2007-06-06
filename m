Return-Path: <linux-kernel-owner+w=401wt.eu-S935747AbXFFUxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935747AbXFFUxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934560AbXFFUwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:52:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:29692 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097AbXFFUww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bnBvIN/BUzaYJRFkp+gQUzO0aRimhrl/8p4YCNUgaG32eWq7wlC9LXNpj40ytZTTXS2zkQz6yCr7ZwaJSUSGuWK0z7kqnIDI9Wetk8zYctdMupRgQhkSkSg8ZodfuS0XgNmwTXleBjqBbmrGnlm9+oWF+9qo1yuL5ozHxkmDqJU=
Message-ID: <b637ec0b0706061352x67dc0dadida65570d77abe6f4@mail.gmail.com>
Date: Wed, 6 Jun 2007 22:52:52 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc4-mm1
Cc: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       "Herbert Xu" <herbert@gondor.apana.org.au>
In-Reply-To: <20070606132439.3f59f0cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	 <200706062132.37430.m.kozlowski@tuxland.pl>
	 <20070606132439.3f59f0cf.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 6/6/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 6 Jun 2007 21:32:36 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
>
> > Hello,
> >
> >       This is from my P4 sony vaio laptop.
> >
> > These warnings still there:
> >
> > drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> > drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> > sound/soc/sh/Kconfig:6:warning: 'select' used by config symbol 'SND_SOC_PCM_SH7760' refers to undefined symbol 'SH_DMABRG'
>
> Yeah, people keep adding those and then never fixing them.  I've given up
> and I just ignore them.

Maybe it is because ATARI_KBD_CORE is defined only in arch/m68k.
