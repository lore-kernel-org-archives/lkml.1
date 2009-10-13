Return-Path: <linux-kernel-owner+w=401wt.eu-S933872AbZJMKdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbZJMKdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933794AbZJMKdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:33:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49247 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933812AbZJMKdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:33:09 -0400
Date: Tue, 13 Oct 2009 12:32:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>, x86team <x86@kernel.org>
Subject: Re: [RFC -tip] apic NOOP driver
Message-ID: <20091013103229.GB3915@elte.hu>
References: <20090924203147.GD5476@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924203147.GD5476@lenovo>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Ingo,
> 
> here is what implemented at moment. Did you mean something like that? 
> Note that it's quite early RFC not for any kind of inclusion.

yeah, this looks pretty good.

And i'd suggest to separate the patches that introduce this APIC driver 
from the changes that make use of it. Makes for an easier bisection 
target.

	Ingo
