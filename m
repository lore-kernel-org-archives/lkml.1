Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbYGAQZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbYGAQZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYGAQY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:24:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:32354 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbYGAQY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:24:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ouSe7YCNZQU6DiOuFGK5hBEnLWC49HDuZQpMmJYK8K83W7uFabSgbZweP30Fyalvnx
         B/90hrdUdA8yPXVgsPEPWx1DizTMSgSUXWKuBxQoJmBQBxW1Skt3wsxEt301NGJ3ujW7
         f0wDMwbnfO4gbeHpXrPOe0r5Yvk7YspFqpPrg=
Date: Tue, 1 Jul 2008 20:24:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: I/O APIC: Add a 64-bit variation of
	replace_pin_at_irq()
Message-ID: <20080701162425.GA7043@cvg>
References: <Pine.LNX.4.55.0807010112360.30785@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807010112360.30785@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Tue, Jul 01, 2008 at 01:19:31AM +0100]
|  When an interrupt is rerouted to a different I/O APIC pin the relevant
| entry of the irq_2_pin list should get updated accordingly so that
| operations are performed on the correct redirection entry.  This is
| already done by the 32-bit variation of the code and here is a
| complementing 64-bit implementation.  Should make someone's decision less
| tough when merging the two. ;)
| 
| Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
| ---

Thanks Maciej :-)

		- Cyrill -
