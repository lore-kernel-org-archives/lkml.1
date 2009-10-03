Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZJCKtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZJCKtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 06:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbZJCKtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 06:49:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51620 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZJCKtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 06:49:24 -0400
Date: Sat, 3 Oct 2009 12:49:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: kprobes fixes
Message-ID: <20091003104923.GA3250@elte.hu>
References: <1254537091-4993-1-git-send-email-fweisbec@gmail.com> <20091003103538.GA12263@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003103538.GA12263@elte.hu>
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


ok, -tip testing found this new failure:

  TEST    posttest
Error: ffffffff8106ac00:        66 0f 73 fd 04          pslldq $0x4,%xmm5
Error: objdump says 5 bytes, but insn_get_length() says 4 (attr:8000)
make[1]: *** [posttest] Error 2
make: *** [bzImage] Error 2

	Ingo
