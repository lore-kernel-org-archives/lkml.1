Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbYKQRKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbYKQRKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYKQRKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:10:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45677 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYKQRKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:10:30 -0500
Date: Mon, 17 Nov 2008 18:10:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
Message-ID: <20081117171005.GA25729@elte.hu>
References: <20081117081117.GD26778@kernel.dk> <20081117082201.GB24603@elte.hu> <20081117083022.GE26778@kernel.dk> <20081117085046.GE28786@elte.hu> <20081117085807.GF26778@kernel.dk> <20081117093425.GG26778@kernel.dk> <20081117094147.GJ28786@elte.hu> <20081117094551.GI26778@kernel.dk> <20081117111350.GJ26778@kernel.dk> <4921A4F3.1030309@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4921A4F3.1030309@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Jens Axboe wrote:
>> One exception is a real bug that this turned up. The XEN balloon driver
>> passes the virt address into kunmap() as well, so that part should go in
>> for 2.6.28. I've CC'ed Jeremy.
>>   
>
> Oops.  Acked-by: Jeremy Fitzhardinge  <jeremy.fitzhardinge@citrix.com>

Could you please send a changelogged fix for x86/urgent, to make sure 
this shows up in .28?

	Ingo
