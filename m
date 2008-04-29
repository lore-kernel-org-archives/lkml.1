Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbYD2Vyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbYD2Vyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYD2Vyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:54:36 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:42797 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbYD2Vyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:54:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G/TXU/ed3a8IGKDxh1PXcUQ9CKp5pjHSZJ6kGqtfi/GmvnstXPWL5lykulm4H2Pq6HIchyjSODbvbxl3uN1zuVYpX5+Qu5MGkCAB660LCdjxpshpkLREInPKsbI6TV6U5D2T5mOTKc5y0Tr5MhxwErBriUm69d9FkYqKxTvihto=
Message-ID: <86802c440804291454n6b5940b4i73efbc89d72077b1@mail.gmail.com>
Date: Tue, 29 Apr 2008 14:54:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to discrete layout v8
Cc: "Yinghai Lu" <yhlu.kernel.send@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080429134617.1bc3b2d5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804281505.05764.yhlu.kernel@gmail.com>
	 <200804290200.33459.yhlu.kernel@gmail.com>
	 <200804290352.33543.yhlu.kernel@gmail.com>
	 <20080429134617.1bc3b2d5.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 1:46 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Tue, 29 Apr 2008 03:52:33 -0700 Yinghai Lu wrote:
>
>  > Index: linux-2.6/Documentation/kernel-parameters.txt
>  > ===================================================================
>  > --- linux-2.6.orig/Documentation/kernel-parameters.txt
>  > +++ linux-2.6/Documentation/kernel-parameters.txt
>  > @@ -595,6 +595,20 @@ and is between 256 and 4096 characters.
>  >                       See drivers/char/README.epca and
>  >                       Documentation/digiepca.txt.
>  >
>  > +     disable_mtrr_cleanup [X86]
>  > +     enable_mtrr_cleanup [X86]
>  > +                     The kernel tries to adjust MTRR layout from continuous
>  > +                     to discrete, to make X server driver able to add WB
>  > +                     entry later. This parameter enables/disables that.
>  > +
>  > +     mtrr_chunk_size=nn[KMG] [X86]
>  > +                     used for mtrr cleanup. It is largest continous chunk
>  > +                     that could hold holes aka. UC entries.
>  > +
>  > +     mtrr_gran_size=nn[KMG] [X86]
>  > +                     used for mtrr cleanup. It is granity of mtrr block.
>
>  s/granity/granularity/
>  I think that's what you mean/want.

thanks.

>
>  How does someone know that size/granity/whatever of an mtrr block?

considering to auto test to find optimal value for mtrr_chunk_size and
mtrr_gran_size...

YH
