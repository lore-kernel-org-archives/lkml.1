Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbXJCTff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbXJCTff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 15:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbXJCTf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 15:35:28 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:27016 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbXJCTf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:35:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=m/bd6B25a1eHCCxEuPiLjvPaDYL21d9Vzjuat7ZndoVvsOK1hvqcHMnahb/BM4PPGYkdED49kiFCssquJ98pU7c4HJWzrhkoq3HcwhdwAWDIkhTSvVsk2oyg4VrRg0nYc1r6JiGJzZNr38pWB7W4tsPZlyPEsikW1SC5+rKq+kc=
Message-ID: <84144f020710031235r29986ceaj3260e8271eee6ddb@mail.gmail.com>
Date: Wed, 3 Oct 2007 22:35:24 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: File corruption when using kernels 2.6.18+
Cc: "Neil Romig" <neil@romig.demon.co.uk>, linux-kernel@vger.kernel.org,
       hyoshiok@miraclelinux.com, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710031209450.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46FFC371.9040805@romig.demon.co.uk>
	 <84144f020709300929t6aafd98at23d810d4460e898a@mail.gmail.com>
	 <4702B28F.5050404@romig.demon.co.uk>
	 <84144f020710022218x147ffc74y477c0a1be3e60d66@mail.gmail.com>
	 <4703E287.3070705@romig.demon.co.uk>
	 <84144f020710031148i346b393bm528fc150fedff00f@mail.gmail.com>
	 <alpine.LFD.0.999.0710031209450.3579@woody.linux-foundation.org>
X-Google-Sender-Auth: ffb1892d3aaaf7ef
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 10/3/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> I would bet that the reason the intel-optimized memcpy triggers this is
> that the non-temporal stores just means that you go out directly on the
> bus, and it probably just shows a weakness in the chipset or bus that
> doesn't show with the normal cacheline accesses.

But that should show up with memtest too, no?

                             Pekka
