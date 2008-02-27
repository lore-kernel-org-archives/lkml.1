Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYB0QAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYB0QAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 11:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYB0QAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 11:00:09 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:37191 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbYB0QAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:00:07 -0500
Date: Wed, 27 Feb 2008 18:59:03 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Martin Michlmayr <tbm@cyrius.com>,
       linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       Ralf Baechle <ralf@linux-mips.org>, linux-crypto@vger.kernel.org
Subject: Re: [2.6.25 patch] drivers/crypto/hifn_795x.c: fix 64bit division
Message-ID: <20080227155901.GA30642@2ka.mipt.ru>
References: <20080226122100.GB22699@deprecation.cyrius.com> <20080226153421.GB10717@cs181133002.pp.htv.fi> <20080226185240.GA2521@2ka.mipt.ru> <20080226160439.5941cc31.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226160439.5941cc31.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 04:04:39PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> udelay() might be exposed to the same problem.  It would be better to fix
> ndelay() and udelay() rather than callers.  It is reasonable to pass a u64
> into ndelay() and to expect the build to not explode.

Well, if you think it is resonable to pass u64 into function, which is 
supposed to sleep no more than several cpu cycles. I do not want to
start any kind of flame about it, but this looks like an overkill.

> (Geeze macros suck)

Absolutely.

-- 
	Evgeniy Polyakov
