Return-Path: <linux-kernel-owner+w=401wt.eu-S933295AbYEBAGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbYEBAGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761564AbYEBAGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:06:18 -0400
Received: from rv-out-0708.google.com ([209.85.198.250]:29082 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932872AbYEBAGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Iw/edh6tKaneeOGkMjaPFQOb5oeSE6PO4+Fbq1uX3kqhG/0Zjbi/EdxbjrxZnhD9k7Jl23DHRgBQRcl3f/ZoQUnIdJ30stzJVti27D4IlfQg+zb8E7376hL8wgfRzIC0PT0fCdQRWrWbzRuMyO4wTJxMjTREUQ/PJHwehMbu7Vc=
Message-ID: <86802c440805011706m51f4840dye0191c7e853d5aa@mail.gmail.com>
Date: Thu, 1 May 2008 17:06:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete - auto detect
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4819AD44.4040200@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804290352.33543.yhlu.kernel@gmail.com>
	 <200804292025.58268.yhlu.kernel@gmail.com>
	 <200805010100.34751.yhlu.kernel@gmail.com>
	 <4819AD44.4040200@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 4:45 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
> Yinghai Lu wrote:
>  > loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal value.
>  >
>  > so user don't need to add mtrr_chunk_size and mtrr_gran_size,
>  >
>  > if optimal value is not found, print out all list to help select less optimal
>  > value.
>  >
>  > add mtrr_spare_reg_nr= so user could set 2 instead of 1, if the card need more entries.
>
>  WOW :)
>
>  With this patch all is working fine , no RAM is lost , X is fast ,
>  so far everything else seems to work fine. \o/
>
>  I will test on 32bit tomorrow and stress the box later on today to be sure everything works fine.
>
>  There is my dmesg , meminfo , mtrr output with this patch on top x86-latest :
>
>  http://frugalware.org/~crazy/mtrr_x86-latest/

while look at that you boot log, it seems there is one bug about hole
position. but I look that code, it should already be handled.

Can you send out boot msg and /proc/mtrr when using
disable_mtrr_cleanup command line?

Thanks

Yinghai Lu
