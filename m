Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZGWUZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZGWUZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 16:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZGWUZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 16:25:23 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52102 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZGWUZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 16:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FOMlIcx9v1dZcu4ZcYSnzlcsp+3a75WNJ1hYzHcZxcQ9vMK8KFv4iU+m9P4RYgpBJR
         FIzi9A8Qcm8YFeTKsfrYPFlsFKOftsUWyR/fnQe2ZpCC1aYMsclgZ+OOUYVDQK/HW4Xc
         hNR1f+NrIDJMusu3PbNYeLFAOAdJVAQIKn7JQ=
MIME-Version: 1.0
In-Reply-To: <4A68A8D9.1020207@nokia.com>
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>
	 <4A6701E3.3000204@csr.com>
	 <63386a3d0907221533u6ab2738dpcb4484595ae757b0@mail.gmail.com>
	 <4A68709E.5060207@csr.com> <4A68A8D9.1020207@nokia.com>
Date: Thu, 23 Jul 2009 22:25:21 +0200
Message-ID: <63386a3d0907231325v42b05454u236c0103ae99a97f@mail.gmail.com>
Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       David Vrabel <david.vrabel@csr.com>, marek.vasut@gmail.com,
       Madhusudhan Chikkature <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/23 Adrian Hunter <adrian.hunter@nokia.com>:

> Have you considered using our enable/disable approach instead?

Didn't see that before, still an ran these patches by Tony... But
yes, I have *indeed* considered that approach and my first patch
was a lot like your, but at the time Pierre said:

> I'm not sure I agree with the design here. What's wrong with using the
> set_ios() callback and the normal clock field?

So I switched to using ios.clock instead, and that's what's been iterated.

That said, *I* am perfectly happy with your patch, so if you send that to
Andrew I will happily drop my patch and adapt the MMCI driver for
your stuff instead if that goes in.

Yours,
Linus Walleij
