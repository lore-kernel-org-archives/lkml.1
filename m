Return-Path: <linux-kernel-owner+w=401wt.eu-S1766016AbYDPPLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766016AbYDPPLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759030AbYDPPL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:11:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43243 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbYDPPL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:11:28 -0400
Date: Wed, 16 Apr 2008 17:10:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v2)
Message-ID: <20080416151054.GA32456@elte.hu>
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416130605.GG6304@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> thanks Mathieu, i've picked this up into x86.git for more testing.

... but had to drop it due to missing PARAVIRT support which broke the 
build. I guess on paravirt we could just initially define 
INTERRUPT_RETURN_NMI_SAFE to iret, etc.?

	Ingo
