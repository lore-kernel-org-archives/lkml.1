Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYF3GqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYF3GqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYF3GqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:46:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55861 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYF3GqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:46:07 -0400
Date: Mon, 30 Jun 2008 08:44:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: stable@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Thorsten Knabe <linux@thorsten-knabe.de>, Jeff Dike <jdike@addtoit.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-2.6.25] x86_64 ptrace: fix sys32_ptrace
	task_struct leak
Message-ID: <20080630064454.GA9561@elte.hu>
References: <483EC624.90503@thorsten-knabe.de> <20080601213134.GJ4018@sequoia.sous-sol.org> <20080602010546.GA8578@c2.user-mode-linux.org> <484719C7.2020502@thorsten-knabe.de> <20080605004925.GA15461@c2.user-mode-linux.org> <484BC4DF.5000605@thorsten-knabe.de> <20080608143434.GF2487@hacking> <20080627204953.EB060154039@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627204953.EB060154039@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> Commit 5a4646a4efed8c835f76c3b88f3155f6ab5b8d9b introduced a leak of 
> task_struct refs into sys32_ptrace.  This bug has already gone away in 
> for 2.6.26 in commit 562b80bafffaf42a6d916b0a2ee3d684220a1c10.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
