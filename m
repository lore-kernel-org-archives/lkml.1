Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216Ab0AQRXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0AQRXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 12:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267Ab0AQRXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 12:23:41 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48906 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0AQRXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 12:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=niQ+wlog37yUlN9qsyBsK44g2cseiRqEwroJ6GHepKVb3sMPSLXf+kxAtc9/lVCIGK
         45MCSOo8jOUiJe2QrwlaBCWNZL/G9xwpw0QuDgCdtlpKqjz2X0F/zblhNniECDsOs2S7
         W41vIYTKEUXY7sZVk+8hD+4SivldI6sOoNYM0=
MIME-Version: 1.0
In-Reply-To: <84144f021001170843s67afae24oaabf09e9b13af8db@mail.gmail.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
	 <20100116174821.GA18306@redhat.com> <201001162257.16277.rjw@sisk.pl>
	 <alpine.LFD.2.00.1001161402400.13231@localhost.localdomain>
	 <20100117123218.GA3182@redhat.com>
	 <84144f021001170618g708a7c14ob1b222ab1cbdaa20@mail.gmail.com>
	 <20100117161726.5752b181@schatten.dmk.lab>
	 <84144f021001170843s67afae24oaabf09e9b13af8db@mail.gmail.com>
Date: Sun, 17 Jan 2010 19:23:35 +0200
X-Google-Sender-Auth: 2130d05bf238e2eb
Message-ID: <84144f021001170923o30d37becw57ebbd780f63b69e@mail.gmail.com>
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 6:43 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Florian,
>
> (Please don't trim the cc list.)
>
> On Sun, Jan 17, 2010 at 5:17 PM, Florian Mickler <florian@mickler.org> wrote:
>> on which side of the merge? linus or drm?
>> i.e. it is to be expected to be before the merge, (but on the drm side)
>> so don't get confused... or did i misunderstood the situation?
>
> Like I said, don't read too much into the results but the current
> situation looks like the regression happened _after_ 2.6.32 but before
> any of the DRM code was merged to 2.6.33-rc1. I don't think that makes
> much sense which is why I'm back to testing 2.6.32 more to see if the
> bug is there already but just harder to trigger for whatever reason.

OK, confirmed. I can see the "flashing" bug with 2.6.32 as well. It
just takes more time to trigger than in 2.6.33-rc1. I am going back to
test 2.6.31 now.
