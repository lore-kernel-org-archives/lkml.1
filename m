Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbYAVUwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbYAVUwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYAVUwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:52:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46805 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbYAVUwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:52:39 -0500
Date: Tue, 22 Jan 2008 21:52:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove BKL from sysctl(2)
Message-ID: <20080122205225.GD12892@elte.hu>
References: <20080122202727.GB1975@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122202727.GB1975@martell.zuzino.mipt.ru>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> /proc/sys part of sysctl code runs without BKL held, so BKL during 
> sysctl(2) is useless. Remove misleading comment and "protection" 
> around coredumping code -- kernel.core_pattern can be written without 
> BKL.
> 
> do_sysctl() and lookup in /proc/sys use identical iterators, so any 
> locking bug BKL supposedly fixed in sysctl(2) code we should have in 
> /proc/sys code anyway.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

cool! You just shortened the grand 10-year-plan of BKL removal by at 
least one year :-)

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
