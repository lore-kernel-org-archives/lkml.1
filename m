Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYDNMVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYDNMVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYDNMV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:21:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:42326 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYDNMV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:21:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WQMaSMGz77B3qtFEnnovZch1scNHxBtT1JLhb5E26u4py0P35cF0eP6guNEuXwlMJGWE8IoLQXljVXMTQktF3HepxI7VVSBbzAJGbfIgg50GoIUh70tF692pUYXPIHBSYUXDmr4qmPZtCVj7SEekYm5DKKfQ8nXqutYFcljsQAQ=
Message-ID: <cfd18e0f0804140521x4a2b97d9h393463b821b380dc@mail.gmail.com>
Date: Mon, 14 Apr 2008 14:21:27 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Erik Bosman" <ejbosman@cs.vu.nl>
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrea Arcangeli" <andrea@cpushare.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <Pine.GSO.4.56.0804141349060.17644@keg.few.vu.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
	 <517f3f820804140357k62b3bff4p555ba6a5b9438c35@mail.gmail.com>
	 <Pine.GSO.4.56.0804141349060.17644@keg.few.vu.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 1:59 PM, Erik Bosman <ejbosman@cs.vu.nl> wrote:
>
>
>
> On Mon, 14 Apr 2008, Michael Kerrisk wrote:
>
> > Erik,
> >
> > Could you CC me please on kernel-userland API changes.
> >
> > Also it would be helpful if you could provide a short paragraph
> > (plaintext is fine) that describes the new commands and would be
> > suitable for inclusion in the prctl.2 (
> > http://www.kernel.org/doc/man-pages/online/pages/man2/prctl.2.html )
> > man page -- would that be possible?
> >
> > Cheers,
> >
> > Michael
> >
>
> .TP
> .B PR_SET_TSC
> (Since Linux 2.6.??, only on x86)
> Set the state of the flag determining whether the timestamp counter
> can be read by the process. Pass
> \fBPR_TSC_ENABLE\fP to \fIarg2\fP to allow it to be read, or
> \fBPR_TSC_SIGSEGV\fP to generate a \fBSIGSEGV\fP when the process tries
> to read the timestamp counter.
> .TP
> .B PR_GET_TSC
> (Since Linux 2.6.??, only on x86)
> Get the state of the flag determining whether the timestamp counter
> can be read from \fIarg2\fP.

Thanks Erik.  Looks good as a first cut -- I may come back to you with
questions.

It sounds like this might go into mainline in 2.6.26, is that right?

Cheers,

Michael
