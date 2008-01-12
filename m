Return-Path: <linux-kernel-owner+w=401wt.eu-S1761213AbYALGbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761213AbYALGbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 01:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbYALGbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 01:31:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55542 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbYALGa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 01:30:59 -0500
Date: Sat, 12 Jan 2008 07:30:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch 0/8] Series to improve the x86 backtracing code
Message-ID: <20080112063036.GA32675@elte.hu>
References: <20080111212623.518e1527@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111212623.518e1527@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> this patch series improves the x86 backtracing code in the following ways:
> 1) Fix a bad bug in x86 (32 bit) FRAME_POINTER backtracing (2.6.24 material)
> 2) Add the capability to mark a backtrace entry as reliable / unreliable
> 3) Change the x86 (32 bit) FRAME_POINTER backtracing to use the normal backtrace but use the frames
>    as guidance to the reliability of the backtrace entries
> 4) Patch to capture the EBP register earlier in the backtrace callchain to get a better FRAME_POINTER
>    based backtrace
> 5) Split the x86 (64 bit) backtrace code up similar to the 32 bit code by turning a macro into a function
> 6) Enable FRAME_POINTER backtracing on 64 bit similar to the 32 bit patch in number 3
> 7) Add a simple self-test module for backtraces (will move to tests/ later when that gets merged)
> 8) Add the feature to x86 64bit to print a set of bytes prior to the current EIP in the Code: line
>    (already present in 32 bit)

thanks, i've applied your new series to x86.git. (Note that i had to 
move around some of the changes to make the series bisectable.)

	Ingo
