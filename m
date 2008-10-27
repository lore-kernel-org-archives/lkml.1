Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbYJ0K5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbYJ0K5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYJ0K5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:57:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbYJ0K5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:57:13 -0400
Date: Mon, 27 Oct 2008 11:57:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Joe Damato <ice799@gmail.com>, linux-x86_64@vger.kernel.org,
       linux-newbie@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] x86: Cleanup idt, gdt/ldt/tss structs
Message-ID: <20081027105708.GB13895@elte.hu>
References: <1224904532-9586-1-git-send-email-ice799@gmail.com> <20081025054018.GU24654@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025054018.GU24654@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> On Fri, Oct 24, 2008 at 08:15:20PM -0700, Joe Damato wrote:
> > Hi -
> > 
> > This is my first submission to the kernel, so (beware!) please let me know if I can make any improvements on these patches.
> 
> It looks like you provide one patch per file. You should group some 
> of them together so that each patch does a functional change and 
> everything still builds after incrementally applying that patch. The 
> way you have splitted them will break builds if someone tries to 
> build after patch 1 for instance.

yes, at every step the kernel is expected to build and boot fine.

	Ingo
