Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbZBDLOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbZBDLOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZBDLOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:14:45 -0500
Received: from gate1.ipvision.dk ([217.195.186.3]:58154 "EHLO
	gate1.ipvision.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZBDLOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:14:44 -0500
X-Greylist: delayed 5564 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Feb 2009 06:14:44 EST
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, zbr@ioremap.net, jarkao2@gmail.com, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
References: <20090203094108.GA4639@ff.dom.local>
	<20090203111012.GA16878@ioremap.net>
	<20090203112431.GA8746@gondor.apana.org.au>
	<20090203.164630.173080148.davem@davemloft.net>
From: Benny Amorsen <benny+usenet@amorsen.dk>
Date: Wed, 04 Feb 2009 10:41:44 +0100
In-Reply-To: <20090203.164630.173080148.davem@davemloft.net> (David Miller's message of "Tue\, 03 Feb 2009 16\:46\:30 -0800 \(PST\)")
Message-ID: <m3skmubktj.fsf@ursa.amorsen.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -6.4 (------)
X-Spam-Report: ALL_TRUSTED=-3.3, BAYES_00=-3.099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Herbert Xu <herbert@gondor.apana.org.au>

>> Granted copying sucks, but this is really because the underlying
>> hardware is badly designed.  Also copying is way better than
>> not receiving at all due to memory fragmentation.
>
> This scheme sounds very reasonable.

Would it be possible to add a counter somewhere for this, or is that
too expensive?


/Benny

