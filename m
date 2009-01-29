Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZA2VYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZA2VYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZA2VYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:24:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:37737 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZA2VYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=N7sXLUkfpBNiTIzmDeVNSknwfgcVL0abj74uJFpkryhkofWTc1YJXlbz+GldgNI0pq
         d7oaFqZ7x9lhjzYqyoEVs2n6QHaxcfOkrZM1p4Su8KDZf2WQl14f7cun4e+dTDlmaJ4V
         iBYqyDsQEn5xAuMmIDcv970iAK0AAFX7fL/vM=
MIME-Version: 1.0
In-Reply-To: <87vdryw6ql.fsf@basil.nowhere.org>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
	 <87vdryw6ql.fsf@basil.nowhere.org>
Date: Thu, 29 Jan 2009 13:24:34 -0800
X-Google-Sender-Auth: fefcdeb1647d48ad
Message-ID: <eada2a070901291324t1a2dbb08hbff7b026c77d69cd@mail.gmail.com>
Subject: Re: x86: unify genapic code, unify subarchitectures, remove old 
	subarchitecture code
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 6:02 AM, Andi Kleen <andi@firstfloor.org> wrote:
> My suggestion would be to deprecate and then remove es7000 and
> numaq too. The es7000 subarch is only for very old es7000 systems (the
> newer ones all work with bigsmp) and I expect the user base is very
> likely zero or very near it. For NUMAQ it's similar -- there's
> apparently one system left at IBM, and I'm sure IBM can find some
> replacement. Especially NUMAQ has some ugly ifdefery outside the
> subarch code too that would be good to remove. Overall that would
> be a good cleanup without impacting the user base really.

The machines (yes plural!) on which we had regular testing happening
have been offline for a few months due to some broader dependencies
(eg: console server in the old product used an old version of windows
that doesn't meet the corporate security standards) and we've just not
managed to get past that.  That in turn is in the way of debugging
boot issues with newer kernels.  At this point the most passionate
Sequent/IBMers caring about the NUMAQ support are resigned to it being
a lost cause.

The main benefit to carrying NUMAQ support along this long was these
machines had a knack for triggering real bugs.  But since there's no
active bug testing happening on them now and it doesn't look like
there will be...

RIP NUMAQ!   (sorry dhansen and apw :)

I believe in the past there've been some let's kill off NUMAQ patches
floated...if anybody has something that applies, go for it.  Else
we'll post something shortly.




Tim
