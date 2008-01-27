Return-Path: <linux-kernel-owner+w=401wt.eu-S1759361AbYA0WjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbYA0WjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYA0WjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:39:02 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:19816 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbYA0WjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:39:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d7Y99pV7DXF1JYCy/LWzAI7Wb6Y6eTjIWDgauBIE8reGLGPlNloyzglkfAv/8cnXnaUfvGvDcTwqvHC/u5d8XHXjZyKT6RmHk4z12KNXr7mChOqnmU1DR3lEjQw2cNZNH1OOtAfQqXuCspgA0U3bx83z62dQXQe46zx+FBOaCKE=
Message-ID: <4d8e3fd30801271438k1a71f2f3j3d0a2969f1c834be@mail.gmail.com>
Date: Sun, 27 Jan 2008 23:38:59 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>
Subject: Re: [PATCH] X86: coding style fixes to arch/x86/math-errors.c - take 2
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <479D067E.3010100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080127231527.2ea40804@paolo-desktop>
	 <479D067E.3010100@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 27, 2008 11:32 PM, Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
[..]
>
> Is there any point in changing code inside the #if 0/#endif block?

Just to avoid checkpatch complaints :-)

> > @@ -76,10 +74,10 @@ void Un_impl(void)
> >  /*
> >     Called for opcodes which are illegal and which are known to result in a
> >     SIGILL with a real 80486.
> > -   */
> > +*/
> >  void FPU_illegal(void)
> >  {
> > -  math_abort(FPU_info,SIGILL);
> > +  math_abort(FPU_info, SIGILL);
> >  }
> >
> >
> > @@ -88,61 +86,69 @@ void FPU_printall(void)
> >  {
> >    int i;
> >    static const char *tag_desc[] = { "Valid", "Zero", "ERROR", "Empty",
> > -                              "DeNorm", "Inf", "NaN" };
> > +                                     "DeNorm", "Inf", "NaN" };
>
> Umm... Why?

I'll remove it.

Thanks.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
