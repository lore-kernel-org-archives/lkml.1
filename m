Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYBPGJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYBPGJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 01:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYBPGJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 01:09:16 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:6714 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbYBPGJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 01:09:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tn2MfCqHWqlUIX05m1HMqrh0xFwIEoyhekRRNW71FRhsxk5OE1xQd3zB9raDuZoH/7pCzEAgIe7eDiO0VvMH8QGPvzAtQCEna4QRQiXZYFYY3k+a4a28e/S152ZpP7LZNPiuuVtpekc59U3DU9bJWjE1UNPXkTGuzOEZyUT+VOA=
Message-ID: <86802c440802152209p34965e70o8f20e957a6487423@mail.gmail.com>
Date: Fri, 15 Feb 2008 22:09:12 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [PATCH 1/5] x86: validate against acpi motherboard resources
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47B67A0E.7060605@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.LKjQjbOw482S/QFVaQ9fSrM+IFw@ifi.uio.no>
	 <fa.wuwhrqFp6CufvpAJxShHqIaOPdI@ifi.uio.no> <47B67A0E.7060605@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 9:52 PM, Robert Hancock <hancockr@shaw.ca> wrote:
> Andi Kleen wrote:
>
> > Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
>  >> [akpm@linux-foundation.org: many fixes and cleanups]
>  >> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>  >> Signed-off-by: Andi Kleen <ak@suse.de>
>  >> Tested-by: Andi Kleen <ak@suse.de>
>  >
>  > iirc it really was
>  > Tested-and-didnt-pass-test-by: Andi Kleen
>  > unfortunately. I have not rechecked recently, but on the one Intel
>  > box the original patch and the other mcfg heuristics removed didn't work.
>
>  With just this patch you will have this problem. You need either the
>  patch to disable decode during BAR sizing, or the patch to use MMCONFIG
>  for extended config space only, if you don't have them already.

linus already apply the the patch to "use MMCONFIG for extended config
space only" to mainline. the last two near 2.6.25-rc1.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a0ca9909609470ad779b9b9cc68ce96e975afff7
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b6ce068a1285a24185b01be8a49021827516b3e1

Andi,
can you double check this patch with your test system?

YH
