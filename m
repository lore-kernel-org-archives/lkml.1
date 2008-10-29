Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYJ2NHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYJ2NHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYJ2NHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:07:04 -0400
Received: from gw.goop.org ([64.81.55.164]:50057 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbYJ2NHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:07:03 -0400
Message-ID: <49085FD2.9090604@goop.org>
Date: Thu, 30 Oct 2008 00:06:26 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with	BIOVEC_PHYS_MERGEABLE
References: <4905A961.9000603@goop.org> <20081027115659.GZ22217@kernel.dk> <20081029080603J.fujita.tomonori@lab.ntt.co.jp> <20081029083713.GE6364@elte.hu> <49082BBC.60302@goop.org> <20081029105113.GA15981@elte.hu> <20081029112504.GA1935@elte.hu> <20081029112745.GT22217@kernel.dk> <20081029113016.GA3751@elte.hu> <49085326.1050408@goop.org> <20081029130338.GA26282@elte.hu>
In-Reply-To: <20081029130338.GA26282@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> uhm, 1/2 changes bio.h. I'll let both patches alone for now ;-)

OK, 1/2 should be applied one way or another.  It's not critical, but it 
avoids duplicating code if/when an arch/io.h wants to override 
BIOVEC_PHYS_MERGEABLE.

    J
