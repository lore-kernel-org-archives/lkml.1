Return-Path: <linux-kernel-owner+w=401wt.eu-S934506AbYBWKO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506AbYBWKO5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933653AbYBWKOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:14:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52736 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933649AbYBWKOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:14:38 -0500
Date: Sat, 23 Feb 2008 11:14:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: clean up e820_reserve_resources
Message-ID: <20080223101425.GF23833@elte.hu>
References: <200802221707.17164.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802221707.17164.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0041]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> e820_resource_resources could use insert_resource instead of 
> request_resource also move code_resource, data_resource, bss_resource, 
> and crashk_res out of e820_reserve_resources.

thanks, applied.

	Ingo
