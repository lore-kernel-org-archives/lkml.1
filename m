Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbYJTHGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbYJTHGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYJTHGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:06:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYJTHGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:06:39 -0400
Date: Mon, 20 Oct 2008 09:06:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/2] Implement %pR to print struct resource content
Message-ID: <20081020070631.GA12131@elte.hu>
References: <20081020040820.C1882DDDEA@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020040820.C1882DDDEA@ozlabs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> + * - 'R' For a struct resource pointer, it prints the range of
> + *       addresses (not the name nor the flags)

> +	case 'R':
> +		return resource_string(buf, end, ptr, field_width, precision, flags);

small dtail: could you please also add the information that this is 
about the kernel-special resource_size_t integer type? That type is used 
more widely than just struct resource.

	Ingo
