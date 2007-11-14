Return-Path: <linux-kernel-owner+w=401wt.eu-S1764041AbXKNBFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764041AbXKNBFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761759AbXKNBFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:05:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761758AbXKNBFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:05:40 -0500
Message-ID: <473A4909.1020609@zytor.com>
Date: Tue, 13 Nov 2007 17:02:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (update)
References: <20071113190040.740103668@polymtl.ca> <4739F609.50501@zytor.com> <20071113192445.GA1463@Krystal> <4739FCA0.4040702@zytor.com> <20071113194550.GA4400@Krystal> <473A017D.2030501@zytor.com> <20071113204033.GB7450@Krystal> <473A166E.3070708@zytor.com> <20071113220227.GB9057@Krystal> <473A26A2.7090007@zytor.com> <20071114003409.GA18032@Krystal>
In-Reply-To: <20071114003409.GA18032@Krystal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Ok, so the most flexible solution that I see, that should fit for both
> i386 and x86_64 would be :
> 
> 
> 1 byte  : "=Q" : Any register accessible as rh: a, b, c, and d.
> 2, 4 bytes : "=R" : Legacy register—the eight integer registers available
>                  on all i386 processors (a, b, c, d, si, di, bp, sp). 
> 8 bytes : (only for x86_64)
>           "=r" : A register operand is allowed provided that it is in a
>                  general register.
> 
> That should make sure x86_64 won't try to use REX prefixed opcodes for
> 1, 2 and 4 bytes values.
> 
> Does it make sense ?
> 

That's probably the best bet.

	-hpa
