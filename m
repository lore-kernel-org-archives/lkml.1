Return-Path: <linux-kernel-owner+w=401wt.eu-S932394AbXGZHQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbXGZHQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762497AbXGZHQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:16:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:9417 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763053AbXGZHQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E8ixbWrXQ7M5WrHuWoCOSqabja5Cb5pPc6IW+7MVuGaledQSgS0rQxZRUMpTzYd0yilWr8oXyaZWxl8N9sOi0VlZXZBnsnsk31pVWo9h00LhfaWUg06apR91UcBWvz56AfnUaeyuvEmECr9JlieqKrfKFeDf6bHD8aJt3Cjq3SA=
Message-ID: <4bacf17f0707260016x14fc1c92s628ae64353663833@mail.gmail.com>
Date: Thu, 26 Jul 2007 09:16:10 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jarek Poplawski" <jarkao2@o2.pl>,
       "Jean-Baptiste Vignaud" <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
In-Reply-To: <1185322771.4175.102.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com>
	 <20070629150759.GC2771@ff.dom.local>
	 <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com>
	 <20070724080534.GC18740@elte.hu> <20070724094202.GA11610@elte.hu>
	 <alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org>
	 <20070724200431.GA22190@elte.hu> <1185322771.4175.102.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/25, Thomas Gleixner <tglx@linutronix.de>:
> (...)

I've tested Jarek's patch, 2 Ingo's patches (2nd and 3rd) and Thomas'
patch (one patch at time of course) - all of them fixed the problem,
but the last one flooded my logs with "Skip resend for irq 17". All
tests were done on 2.6.21.3.

I wanted to test them all on 2.6.22.1, but I didn't have enough time.
I've verified only that 2.6.22.1 has the same problem. I can test it
later, but I can report results back at beginning of next week.

Regards,
Marcin Slusarz
