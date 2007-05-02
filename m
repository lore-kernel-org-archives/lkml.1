Return-Path: <linux-kernel-owner+w=401wt.eu-S2993413AbXEBPzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993413AbXEBPzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993415AbXEBPzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:55:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:25651 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993413AbXEBPzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=S8Nd/ldMjJSKyVgBFYVLBnRoxSJdM5Zt9b2mfVNi9tqre4OGnNOHSAeaDwXEHSZox9+LXwuIrgrc1Dk0Fq3kTGctCfy8Ue1Zc1WDRAPfucuxOTlz0rMzScH4tSD/13yXm1uAk4ezxNjRXPcYX8qVQ7FlqbUP83xqu997okmJiAE=
Message-ID: <84144f020705020855q6e68381el899261fa30f60cc4@mail.gmail.com>
Date: Wed, 2 May 2007 18:55:29 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/6] firewire: handling of cards, buses, nodes
Cc: linux-kernel@vger.kernel.org, "Kristian H??gsberg" <krh@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       "Christoph Hellwig" <hch@infradead.org>
In-Reply-To: <tkrat.350cb4dfe522266e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4637A29F.6070302@redhat.com>
	 <20070502090007.GA28174@infradead.org>
	 <tkrat.087ee29add656926@s5r6.in-berlin.de>
	 <tkrat.350cb4dfe522266e@s5r6.in-berlin.de>
X-Google-Sender-Auth: af8ff1e029ba7f05
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> +/* The lib/crc16.c implementation uses the standard (0x8005)
> + * polynomial, but we need the ITU-T (or CCITT) polynomial (0x1021).
> + * The implementation below works on an array of host-endian u32
> + * words, assuming they'll be transmited msb first. */
> +u16
> +crc16_itu_t(const u32 *buffer, size_t length)
> +{

[snip]

So put it in lib/crc-itu-t.c? Btw, there's apparently another ITU-T
implementation floating around by Ivo van Doorn.
