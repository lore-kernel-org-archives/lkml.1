Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbXEWWum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbXEWWum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbXEWWud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:50:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:7715 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081AbXEWWub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:50:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ak5xSk0mRyO+KDP8k8B7/aPC1VBQfm1LziuHTsKP23nAoczuVCN6aivpw2frbEj2JG/MtYL6VFWMQ7zJUEz72PaAk65TeRyqVHZ6NnumZ7OlcJGapiEVWRWIi4WVQYhjs43RKKmX+QKH03VrBYnq32nwKXcsc1aZ3By01SHGotw=
Message-ID: <2c0942db0705231550x70432ceaw1d428d7a25ffe8aa@mail.gmail.com>
Date: Wed, 23 May 2007 15:50:29 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Cc: "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070523125100.GA826@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519204504.GA24704@khazad-dum.debian.net>
	 <20070520035259.GA13224@khazad-dum.debian.net>
	 <20070521222339.GF11115@waste.org>
	 <20070521230349.GA645@khazad-dum.debian.net>
	 <20070522224515.GW11115@waste.org>
	 <20070523001943.GA3743@khazad-dum.debian.net>
	 <20070523014825.GX11115@waste.org>
	 <20070523041958.GA15952@khazad-dum.debian.net>
	 <2c0942db0705222141se133553re06370476d436b12@mail.gmail.com>
	 <20070523125100.GA826@khazad-dum.debian.net>
X-Google-Sender-Auth: ff48b8ad7eee87cc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Tue, 22 May 2007, Ray Lee wrote:
> > On 5/22/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > >We don't agree there, as you are not talking about a stable kernel series.
> >
> > Ah, so you're planning on submitting these patches for 2.7 then? 2.6
> > is perpetually stable. Matt is quite correct; feel free to ask for
> > clarifications from Linus et al if you need guidance.
>
> 2.6.x.y is stable.  2.6.x is not by any reasonably strict definition of
> stable.  Unless you can explain how the stuff that went in 2.6.21 could be
> added to a stable series kernel, do not even bother replying.

I owe you an apology, I was a bit snippy there. However, to answer
your question, they got in by accident and lax testing on the part of
the submitters. As someone who has written and maintains a lot of
deployed software that gets upgraded live, I feel comfortable in
saying that maintaining a perpetually stable software series while
allowing new features is entirely possible.

The problem is when the maintainers/submitters get the wrong
impression, that 2.6.x.y is there to clean up the mess they made. The
best of all worlds, in terms of everybody's time spent debugging and
fixing, is if the patches are well-tested before submission. If the
submitters feel that 2.6.x is an unstable series, then they have no
reason to heavily test that code before it goes in.

Which is the crux of my problem with your statement. I feel we
shouldn't give the wrong idea to those authors. They need to know that
the expectation is that 2.6.x is a stable series, and 2.6.x.y is for
dealing with unavoidable mistakes.

> And for the record, the patches are NOT mine, but since I am the one usually
> dealing directly with thinkpad firmware, I jumped in to help debug things as
> a thinkpad firmware was *probably* to blame.

Again, my apologies; I was out of line. Thanks for helping.

Ray
