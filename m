Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbZAGLYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbZAGLYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 06:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZAGLY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 06:24:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52486 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbZAGLYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 06:24:25 -0500
Date: Wed, 7 Jan 2009 12:24:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Leonardo Potenza <lpotenza@inwind.it>
Cc: kernel-janitors@vger.kernel.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: fix section mismatch warnings in
	mcheck/mce_amd_64.c
Message-ID: <20090107112410.GB30522@elte.hu>
References: <200901062358.29954.lpotenza@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901062358.29954.lpotenza@inwind.it>
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


* Leonardo Potenza <lpotenza@inwind.it> wrote:

> From: Leonardo Potenza <lpotenza@inwind.it>
> 
> The function local_allocate_threshold_blocks() has been marked 
> __cpuinit, in order to remove the following section mismatch messages:

applied to tip/x86/urgent, thanks Leonardo!

	Ingo
