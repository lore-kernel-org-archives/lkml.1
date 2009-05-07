Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZEGMwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZEGMwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZEGMwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:52:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57739 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbZEGMwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:52:01 -0400
Date: Thu, 7 May 2009 14:51:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/4] kernel: constructor support
Message-ID: <20090507125107.GL28398@elte.hu>
References: <20090507124556.041286732@linux.vnet.ibm.com> <20090507124557.003153444@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507124557.003153444@linux.vnet.ibm.com>
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


* Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> +typedef void (*ctorcall_t)(void);

that name is pretty ugly. Please change it to the usual kernel 
convention for function pointers:

	typedef void (*ctor_fn_t)(void);

Thanks,

	Ingo
