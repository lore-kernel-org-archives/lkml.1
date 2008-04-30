Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbYD3Sm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbYD3Sm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbYD3Sms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:42:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51401 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYD3Smr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:42:47 -0400
Date: Wed, 30 Apr 2008 20:42:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 4/4] mm: Unexport __alloc_bootmem_core()
Message-ID: <20080430184235.GD3008@elte.hu>
References: <20080430170521.246745395@symbol.fehenstaub.lan> <20080430170840.176104554@symbol.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430170840.176104554@symbol.fehenstaub.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Johannes Weiner <hannes@saeurebad.de> wrote:

> This function has no external callers, so unexport it.  Also fix its
> naming inconsistency.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> CC: Ingo Molnar <mingo@elte.hu>
> ---
> 
> It could be argued that all bootmem alloc function names begin with 
> underscores.  But I chose to `no _core function names begin with 
> underscores' :)

lol :) The double underscores definitely prove it that this code was 
originally written by me ;-)

	Ingo
