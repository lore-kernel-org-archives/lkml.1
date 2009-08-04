Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbZHDJMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbZHDJMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbZHDJML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:12:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42987 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558AbZHDJMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:12:10 -0400
Date: Tue, 4 Aug 2009 11:11:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: a.p.zijlstra@chello.nl, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Read buffer overflow
Message-ID: <20090804091155.GA29542@elte.hu>
References: <4A757BCF.40101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A757BCF.40101@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roel Kluin <roel.kluin@gmail.com> wrote:

> Check whether index is within bounds before testing the element.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied, thanks Roel.

A small request for future patches: please always put a verb into 
Linux kernel patch titles. I.e. instead of:

  perf: Read buffer overflow

use something like:

  perf: Fix read buffer overflow

this holds for all the other patches you sent to lkml as well.

Thanks,

	Ingo
