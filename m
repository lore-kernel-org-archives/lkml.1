Return-Path: <linux-kernel-owner+w=401wt.eu-S937374AbYD1TDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937374AbYD1TDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936706AbYD1TDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:03:24 -0400
Received: from rv-out-0708.google.com ([209.85.198.245]:30343 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936278AbYD1TDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:03:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NWV6iFNEZbKnrMXsjZt+naIbeh+1R8yoqxWYi34G+OkKYpiFMiRmBIha9onmBapZt5LMxTernGeXHajkEzRHoyYKyxhVJZE9WT6wcfa8VM5Der8JJaJABnb7X90axC9OGGliBY/Wo/1Hstxk8MMkEhLzA0wuYNRpcCsClr/4jvI=
Message-ID: <86802c440804281203m1c24322fs8ad937016e791bb1@mail.gmail.com>
Date: Mon, 28 Apr 2008 12:03:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mika Fischer" <mika.fischer@zoopnet.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, balajirrao@gmail.com,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <4815A1D4.8000204@zoopnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <200801221623.20861.yinghai.lu@sun.com>
	 <20080426035614.a30afb17.akpm@linux-foundation.org>
	 <48132665.8050202@googlemail.com>
	 <86802c440804272344yac6a9f0n40809169424247e6@mail.gmail.com>
	 <48159668.5010808@googlemail.com>
	 <86802c440804280234y5b38b4bds330fc1a6987202c5@mail.gmail.com>
	 <48159ECF.9020004@googlemail.com> <4815A0D7.9030403@googlemail.com>
	 <4815A1D4.8000204@zoopnet.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 3:07 AM, Mika Fischer <mika.fischer@zoopnet.de> wrote:
> Gabriel C schrieb:
>
> > BTW I just saw , there is this warning now :
>  >
>  > [    0.305539] mtrr: your CPUs had inconsistent variable MTRR settings
>  > [    0.305546] mtrr: probably your BIOS does not setup all CPUs.
>  > [    0.305553] mtrr: corrected configuration.
>  >
>  > but everything seems to work fine.
>
>  Just, FYI, I got this warning too. I didn't get it before applying the patch.

that is normal. because APs will copy the changes of MTRR from BP.
could add some condition for the print out.

YH
