Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbXEBJfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbXEBJfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbXEBJfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:35:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:63401 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbXEBJfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RIGmYbut0JC9WNcP20UXZFwqJL7ieg0uALYbXeMML4bXtx96S0xBJ4taOP7oGqfwfRTcoSVGddp13WWQvP+ttXXVcX41MdgmSLFR4XT7znRxpKDgXrHxn+iK0+7+Wfi5g0BccFw5n35lvefeF1DzTpyOSCbjF6K39JGNl1E7xb0=
Message-ID: <84144f020705020235k3d984ccbv83910f6a6aa48f41@mail.gmail.com>
Date: Wed, 2 May 2007 12:35:46 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Richard Purdie" <richard@openedhand.com>
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
Cc: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       torvalds@osdl.org, "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <1178096183.5860.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1178096183.5860.25.camel@localhost.localdomain>
X-Google-Sender-Auth: d84915167c36b954
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Richard Purdie <richard@openedhand.com> wrote:
> I realise a maze of ifdefs still remain. I've already spent a lot of
> time removing a ton of them and going much further might start to affect
> diffability of the code - I hoping whats there is a good compromise.

I really don't think this is suitable for inclusion in the kernel. Any
reason why you don't just fork the code and clean it up properly? Sure
it will take some more work to track the original but how hard can it
be for ~1700 lines of code?
