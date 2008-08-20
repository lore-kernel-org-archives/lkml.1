Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYHTKU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYHTKU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYHTKUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:20:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43703 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbYHTKUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:20:20 -0400
Date: Wed, 20 Aug 2008 12:19:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Oruba <peter.oruba@amd.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Max Krasnyansky <maxk@qualcomm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2/2 -tip] x86-microcode: generic interface refactoring
Message-ID: <20080820101956.GG28492@elte.hu>
References: <1219184546.10426.41.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219184546.10426.41.camel@earth>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> This is the 1st patch is series. Here the aim was to avoid any 
> significant changes, logically-wise.
> 
> So it's mainly about generic interface refactoring: e.g. make 
> microcode_{intel,amd}.c more about arch-specific details and less 
> about policies like make-sure-we-run-on-a-target-cpu (no more 
> set_cpus_allowed_ptr() here) and generic synchronization (no more 
> microcode_mutex here).
> 
> All in all, more line have been deleted than added.
> 
> 4 files changed, 145 insertions(+), 198 deletions(-)

very nice refactoring! I've applied this patch and your fix to 
tip/x86/microcode for more testing.

	Ingo
