Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbYGIL6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbYGIL6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbYGIL6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:58:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbYGIL6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:58:03 -0400
Date: Wed, 9 Jul 2008 13:57:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] early params NULL pointer deref fix
Message-ID: <20080709115746.GA19060@elte.hu>
References: <486f61a9.1e35440a.5815.ffffbc7d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486f61a9.1e35440a.5815.ffffbc7d@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

>  This series fix a possible NULL pointer deref in case if user was 
> stupid enough to pass boot parameter without a mandatory value
> 
>  Actually there is a number of such issues on other platforms too 
> (like powerpc, sh, s390) so I think it should be fixed too (any 
> volunteers?)
> 
>  Any comments are welcome.

thanks Cyrill, i picked them up.

I'm wondering, would it be possible to filter NULL out on one higher 
level? Would it break any existing functionality? (i dont think it would 
or should)

	Ingo
