Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab0BEOQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:16:48 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41286 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962Ab0BEOQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:16:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pz+7kJsFUeKFUL9Qj1J02WY8FHjGNCcBN7QwcVYhTadi/dLFqxhylDDTcknFvBE/ij
         dZWSN/MIsZJYzviXH5ii/ptq7e/SIwTAkqVXV00Inf3XpjrRbjrob/aqqfJuyvDstghW
         e0H9L/jUPzWh+mLjYHB+PW5vWaPt91YtY1Caw=
MIME-Version: 1.0
In-Reply-To: <20100205132219.GA6874@faui49.informatik.uni-erlangen.de>
References: <20100205132219.GA6874@faui49.informatik.uni-erlangen.de>
From: roel kluin <roel.kluin@gmail.com>
Date: Fri, 5 Feb 2010 15:16:25 +0100
Message-ID: <25e057c01002050616x59c927fbpaf13f477ec012ec5@mail.gmail.com>
Subject: Re: [PATCH] obsolete config in kernel source (USE_INTERNAL_TIMER)
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: Samuel Ortiz <samuel@sortiz.org>, "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>        As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
>
>        USE_INTERNAL_TIMER is another candidate. As can be seen on the
> comment of the #undef instruction this part was quite likely never
> working and safeguards were added si it is never enabled.
>
>        Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.
>
> Regards
>
>        Christoph Egger
>
> [0] http://vamos1.informatik.uni-erlangen.de/
>
> ----
> From f027b61661aaac1fd58536e17894e486d5fb3d3f Mon Sep 17 00:00:00 2001
> From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> Date: Fri, 5 Feb 2010 13:11:16 +0100
> Subject: [PATCH] USE_INTERNAL_TIMER explicitely #undef-ed and not in kconfig
>
> CONFIG_USE_INTERNAL_TIMER seems to be the remainings of some
> experiment. It is explicitely #undef-ed as not working, only
> referenced from one source file and rather aged.
>
> Hereby cleaning it from the kernel tree.
>
> Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>

Looks correct to me,

Acked-by: Roel Kluin <roel.kluin@gmail.com>
