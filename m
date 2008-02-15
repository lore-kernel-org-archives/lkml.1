Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbYBOURd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbYBOURd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762165AbYBOURF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:17:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39202 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762081AbYBOURD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:17:03 -0500
Date: Fri, 15 Feb 2008 21:16:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
Message-ID: <20080215201640.GA6200@elte.hu>
References: <20080201191414.961558000@sgi.com> <20080201191415.450555000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201191415.450555000@sgi.com>
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


* travis@sgi.com <travis@sgi.com> wrote:

>  include/asm-generic/vmlinux.lds.h |    2 +
>  include/linux/percpu.h            |    9 ++++-

couldnt these two generic bits be done separately (perhaps a preparatory 
but otherwise NOP patch pushed upstream straight away) to make 
subsequent patches only touch x86 architecture files?

	Ingo
