Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbYFWVNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbYFWVNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYFWVNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:13:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbYFWVNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:13:45 -0400
Date: Mon, 23 Jun 2008 23:13:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SGI UV: uv_ptc_proc_write security hole
Message-ID: <20080623211335.GA12877@elte.hu>
References: <E1KAm9h-0002Fe-8a@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KAm9h-0002Fe-8a@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> Someone could write 0 bytes to /proc/sgi_uv/ptc_statistics,
> causing
>   optstr[count - 1] = '\0';
> to write to who-knows-where.
> 
> (Andi Kleen noticed this need from a patch I sent for
>  similar code in the ia64 world (sn2_ptc_proc_write()).)
> 
> (count less than zero is not possible here, as count is unsigned)
> 
> Diffed against 2.6.26-rc6

applied to tip/x86/uv - thanks Cliff.

	Ingo
