Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYATT37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYATT37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 14:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYATT3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 14:29:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:15550 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbYATT3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 14:29:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z+mfzcllcY/wPadD5JFh8D/nVipDzDy2eL67QFhxlX5u8Rhm6vCSTAFAoFORRP8C7wvy6ARCFJAQce5GLgBQV4K5sKghij+MakJCtgk+RoAZsrKcWduDlYvBKvC25Jm7SgXdeWUKUEv1XeGzIgdALECCyTBRgSjicAUJ84z62Wk=
Message-ID: <519a8b110801201129kd4347d5mf87920f69cf1821e@mail.gmail.com>
Date: Sun, 20 Jan 2008 20:29:47 +0100
From: xming <xmingske@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Cannot boot xen DomU > 2.6.23.1
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
In-Reply-To: <479394D9.50104@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <519a8b110801170813h96b8f2by795e6d8b72a00ba4@mail.gmail.com>
	 <478F8D22.60004@goop.org>
	 <519a8b110801171113y20a3bedfg446e29a30712a26d@mail.gmail.com>
	 <4790561E.9040508@goop.org>
	 <519a8b110801180438l389ec1d6t7b888b8c78d59dd8@mail.gmail.com>
	 <4790D187.8050000@goop.org>
	 <519a8b110801180856o7757889as47106fd3eabcc0de@mail.gmail.com>
	 <4790E13D.5040603@goop.org>
	 <519a8b110801200508l1fb3dee9ha197f3fc76ccac69@mail.gmail.com>
	 <479394D9.50104@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 20, 2008 7:37 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> xming wrote:
> > ok I have done some of them, but I still don't know what I should be looking
> > at. Do you mean code related to xen or code related to have_vcpu_info_placement?
> > Please be patient with me :)
> >
> > I just paste some of the result (around those addresses) here:
> >
>
> Thanks, that answers that particular question; the vcpu is blocked
> waiting for something to happen, which probably means it missed the
> event which was supposed to wake it up.  Why is another question.  At
> least there's a workaround, and that workaround gives me some clue where
> to look.

Want me to test it?

> BTW, is it an SMP or UP domain?   Does it make a difference?

It doesn't matter, I tried vcpu=1 and vcpu=2, unless you want me to try
to recompile a UP kernel?

> >> OK, good.  I Didn't Break It (tm) ;)
>
> > So no fix from you? :)
>
> Maybe when I have nothing else to do.

I'll wait, or should I poke xen-devel?
