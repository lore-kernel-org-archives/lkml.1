Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYDGIK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYDGIK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYDGIKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:10:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39060 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbYDGIKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:10:15 -0400
Date: Mon, 7 Apr 2008 10:09:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 0/9] x86: cleanup patches
Message-ID: <20080407080955.GA3066@elte.hu>
References: <47f7837a.0b0c360a.3214.ffffe4e7@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47f7837a.0b0c360a.3214.ffffe4e7@mx.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0319]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This is random collection of patch for x86. Mainly each of patch 
> attempts to clean up and increase readability of code.

thanks Akinobu, i've applied the first 6 patches - they are really nice 
cleanups.

The final 3 look good too but there's a patch conflict here: they were 
for mpparse_*.c which has just been unified in x86.git. Would you mind 
to have a look whether they are still relevant to the new mpparse.c? 
(Note, it's not available yet, will push that tree out later today)

	Ingo
