Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055Ab0AUEWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0AUEWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713Ab0AUEWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:22:37 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:47363 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab0AUEWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=haU3ZIOmsELYn1qL7zZcNT4HLYqU0H53MwZwrNR228G22LELI2zzVjZkValq1KgEjE
         n6QatjAnym3XR04GyIIC8EkpNjjHuFzgOFMYg8uXpLS+YYdYLqApUbiUwB8LGhaHTqoa
         d1U3MY40a/SMF/jg7WAiLUeJWDTvY5simg/Iw=
MIME-Version: 1.0
In-Reply-To: <20100120171901.b2e06465.sfr@canb.auug.org.au>
References: <20100120171901.b2e06465.sfr@canb.auug.org.au>
Date: Thu, 21 Jan 2010 10:22:19 +0600
Message-ID: <b9df5fa11001202022q22c2d81cs5b90f694be37c1f4@mail.gmail.com>
Subject: Re: linux-next: tty tree build warning
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/20/10, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Greg,
>
>  Today's linux-next build (x86_64 allmodconfig) produced this warning:
>
>  drivers/char/ip2/ip2main.c:511: warning: 'ip2_setup' defined but not used
>
Can we use module parameters? A check could be made if parameter hasn't
passed then we'll just return.

>  Introduced by commit 3f042287578018e0dc1c38b6f684767e657db62f ("ip2:
>  remove #ifdef MODULE from ip2main.c").
>
>  __setup() is a noop if CONFIG_MODULE is defined.
>
> --
>  Cheers,
>  Stephen Rothwell                    sfr@canb.auug.org.au
>  http://www.canb.auug.org.au/~sfr/
>
>
