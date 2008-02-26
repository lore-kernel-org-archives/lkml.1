Return-Path: <linux-kernel-owner+w=401wt.eu-S1763266AbYBZR3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763266AbYBZR3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759650AbYBZR32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:29:28 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:55107 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbYBZR32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:29:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QTr+tT9GLsd5yujgDKCiJVefwLm5vTgE6iyBB2H+uPvJJWhKKJui4rOYqH8oSBf7Mp8D5kUGxR+SKqo8gSa5CkvHDALqIOfJIkdU4/+bigjD7VRkcmkdpRmcIkD52XCjnQ0qZEtX8M8YDBURUrgJ/tNn8CQSisdpriyzxsyXX+k=
Message-ID: <86802c440802260929tc8f7a19i73552b0e5928e570@mail.gmail.com>
Date: Tue, 26 Feb 2008 09:29:25 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: remove wrong setting about CONSTANT_TSC for intel cpu
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <47C3C0D1.1020304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802252320.01534.yinghai.lu@sun.com>
	 <20080226072035.GB24820@elte.hu>
	 <86802c440802252324u769f087fw83caa26c1960354e@mail.gmail.com>
	 <47C3C0D1.1020304@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:33 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>  >>  which is the same. set_cpu_cap() is indeed the cleaner form to do this
>  >>  so your patch is correct as a cleanup.
>  > set_cpu_cap is right
>  > ==
>  > set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability); ===> is wrong
>  > should be
>  > set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
>  >
>  > x86_capability is a array ...
>  >
>
>  For an array, the & is optional and has no effect.

good to know.

YH
