Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZAZNaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZAZNaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbZAZN3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:29:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38213 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZAZN3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:29:53 -0500
Date: Mon, 26 Jan 2009 14:29:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Adam Wendt <thelsdj@gmail.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] xen: unitialised return value in
	xenbus_write_transaction
Message-ID: <20090126132943.GB13567@elte.hu>
References: <03f51a1eb4a7e77d6488.1232785367@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03f51a1eb4a7e77d6488.1232785367@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0020]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ian Campbell <ian.campbell@citrix.com> wrote:

> The return value of xenbus_write_transaction can be uninitialised in
> the success case leading to the userspace xenstore utilities failing.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Adam Wendt <thelsdj@gmail.com>
> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> 
> ---
>  drivers/xen/xenfs/xenbus.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)

applied to tip/x86/urgent, thanks Ian!

	Ingo
