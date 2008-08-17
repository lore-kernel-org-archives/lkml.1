Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbYHQJZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbYHQJZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 05:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYHQJZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 05:25:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43137 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbYHQJZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 05:25:28 -0400
Date: Sun, 17 Aug 2008 11:24:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: dhowells@redhat.com, serue@us.ibm.com, casey@schaufler-ca.com,
       morgan@kernel.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] security.h: fix build failure
Message-ID: <20080817092439.GA20498@elte.hu>
References: <20080817013420.GA7622@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080817013420.GA7622@orion>
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


* Alexander Beregalov <a.beregalov@gmail.com> wrote:

> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> security.h: fix build failure
> 
> include/linux/security.h: In function 'security_ptrace_traceme':
> include/linux/security.h:1760: error: 'parent' undeclared (first use in this function)

i just triggered this too on today's -git with this config:

   http://redhat.com/~mingo/misc/config-Sun_Aug_17_11_02_11_CEST_2008.bad

and your fix solves it.

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
