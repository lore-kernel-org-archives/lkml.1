Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYIHSDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYIHSDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYIHSDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:03:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56524 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbYIHSDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:03:35 -0400
Date: Mon, 8 Sep 2008 20:03:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Hugh Dickens <hugh@veritas.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Rafa? Mi?ecki <zajec5@gmail.com>
Subject: Re: [PATCH 5/3] x86: fix compile error with corruption checking
	disabled
Message-ID: <20080908180321.GC29264@elte.hu>
References: <patchbomb.1220777491@localhost> <72081a970effa1a32861.1220777494@localhost> <20080907091112.GA5574@elte.hu> <48C3A0DC.8000206@goop.org> <20080907154055.GA31025@elte.hu> <20080907155030.GA24741@elte.hu> <20080907155115.GA28495@elte.hu> <48C44DA1.8060402@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C44DA1.8060402@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Fix compile error:
>  arch/x86/mm/init_32.c: In function 'mem_init':
>  arch/x86/mm/init_32.c:908: error: implicit declaration of function 'start_periodic_check_for_corruption'
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

applied to tip/x86/memory-corruption-check - thanks Jeremy.

	Ingo
