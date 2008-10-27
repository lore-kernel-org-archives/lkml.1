Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbYJ0LBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbYJ0LBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYJ0LBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:01:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbYJ0LBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:01:40 -0400
Date: Mon, 27 Oct 2008 12:01:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 2/4] Hypervisor detection and get tsc_freq from
	hypervisor
Message-ID: <20081027110134.GC13641@elte.hu>
References: <1224894104.28224.72.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224894104.28224.72.camel@alok-dev1>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alok Kataria <akataria@vmware.com> wrote:

> The DMI + Backdoor [...]

please do _NOT_ call anything like this a "backdoor", anywhere in the 
source or the commit log. "Backdoor" is most commonly used for 
intentional security holes, and we dont want anything like that in the 
kernel code. What this code implements is not a backdoor, it is simply 
a facility to discover the hypervisor environment, not a "backdoor".

	Ingo
