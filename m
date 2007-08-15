Return-Path: <linux-kernel-owner+w=401wt.eu-S932790AbXHOPbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbXHOPbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762285AbXHOPbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:31:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:1980 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760963AbXHOPba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=C2Qvcw8cWMt9/x8Wi4fojqleR6pWkpgGnYNG5y2ievfhUHkGLuOhOvFr740QNS9SIUlwPB+6xuDXj49L6mzMMlT4LSp1q5kc6xLo1y3KAKR7ZlMSAL41YLLb6pfP5jmpe6KR/2sgiJGB09Cxjgh033+t4EWhRmmlOVjGhxvSfnU=
Message-ID: <2c0942db0708150831k3bdf941u540b74b6b351920f@mail.gmail.com>
Date: Wed, 15 Aug 2007 08:31:28 -0700
From: "Ray Lee" <ray@madrabbit.org>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Joe Perches" <joe@perches.com>, "Rene Herman" <rene.herman@gmail.com>,
       git@vger.kernel.org, "Junio C Hamano" <gitster@pobox.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46C2C762.7080205@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186984174.10249.7.camel@localhost>
	 <1187054366.2757.0.camel@laptopd505.fenrus.org>
	 <46C10AA8.3090505@gmail.com>
	 <20070814102033.604c8695@the-village.bc.nu>
	 <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost>
	 <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost>
	 <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org>
	 <46C2C762.7080205@s5r6.in-berlin.de>
X-Google-Sender-Auth: ec80dad91ca477c9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Linus Torvalds wrote:
> >       #!/bin/sh
> >       git log --since=6.months.ago -- "$@" |
> >               grep -i '^    [-a-z]*by:.*@' |
> >               sort | uniq -c |
> >               sort -r -n | head
> >
> > and it gives you a rather good picture of who is involved with a
> > particular subdirectory or file.
>
> No, it doesn't.  The subscribers of <subsystem-devel@somewhere.org> are
> not listed in patch logs.

Then maybe they should be added into the patch logs. A CC: line isn't
that big of a deal, and also shows who got notified.
