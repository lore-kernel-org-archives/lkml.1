Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbYA1OBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbYA1OBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbYA1OBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:01:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48835 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbYA1OBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:01:14 -0500
Date: Mon, 28 Jan 2008 15:00:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: change aper valid checking sequence
Message-ID: <20080128140056.GA27928@elte.hu>
References: <200801251813.48961.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801251813.48961.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1116]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_64: change aper valid checking sequence
> 
> old sequence:
> size ==> >4G  ==> point to RAM
> changed to
> >4G ==> point to RAM ==> size
> 
> some bios even leave aper to unclear, so check size at last.
> to avoid reporting that like
> 
> Node 0: Aperture @ 4a42000000 size 32 MB
> Aperture too small (32 MB)
> 
> with patch will get
> 
> Node 0: Aperture @ 4a42000000 size 32 MB
> Aperture beyond 4G. Ignoring.

thanks, applied.

	Ingo
