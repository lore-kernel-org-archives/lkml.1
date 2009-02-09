Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZBIOGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZBIOGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZBIOGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:06:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37712 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbZBIOGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:06:31 -0500
Date: Mon, 9 Feb 2009 15:06:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCHSET x86/master] add stack protector support for x86_32
Message-ID: <20090209140610.GA21560@elte.hu>
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <20090209135557.GB14785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209135557.GB14785@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > This patchset contains the following eleven patches.
> 
> Note, i sorted out the dependencies (it depended on x86/uaccess) and have put the 
> commits into tip:core/percpu. I might not get around testing it today and pushing 
> it out into tip:master, but i pushed out the core/percpu bits, should you queue up 
> further changes.

Note that i spread the patches the following way: #001-003 are in tip:x86/urgent, 
and tip:core/percpu merges in x86/urgent, x86/uaccess and rc4 - and #004-011 go on 
top of that.

(That way we avoid having to cherry-pick #001-003.)

	Ingo
