Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbXLVNtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbXLVNtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXLVNtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:49:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:10614 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXLVNtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:49:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JlM+2zrkCpOXNTezspWEmk2q2xjHF82Fo7/EG8xVYzKFgy5ity6ShJpEgkvNZ/WUKp75FE+PpY2F/4KRsbTBabc0KoHVbL8O78aDXFjmDnIqTTu7b4+rZVaMzKfQOkwltYKs73iugLYMis3VHkq/ci+z84iyk5mH8MRqlbLZqhY=
Message-ID: <84144f020712220549x52bbfff3jc86c643718676629@mail.gmail.com>
Date: Sat, 22 Dec 2007 15:49:23 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] slub: /proc/slabinfo ABI compatibility
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, clameter@sgi.com, a.p.zijlstra@chello.nl
In-Reply-To: <20071222134010.GA12294@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI>
	 <20071222131456.GA32558@elte.hu>
	 <84144f020712220531x238da99bi19ff06aaddfc5fc3@mail.gmail.com>
	 <20071222134010.GA12294@elte.hu>
X-Google-Sender-Auth: 0827acd573fd4bf8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Dec 22, 2007 3:40 PM, Ingo Molnar <mingo@elte.hu> wrote:
> ah, didnt see that. Could you pick up bits of my patch because it seems
> to do a better job, such as proper c99 initializer:

[snip]

> also, my patch fixes all the warnings as well, not just the errors. So
> please give it a second look ;-)

Sure, I'm fine with that. Can you Andrew please drop mine and use
Ingo's instead?

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
