Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbZHXG7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbZHXG7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZHXG7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:59:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45245 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZHXG7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:59:42 -0400
Subject: Re: linux-next: tip tree build failure
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090824165449.559d1597.sfr@canb.auug.org.au>
References: <20090824165449.559d1597.sfr@canb.auug.org.au>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 08:58:56 +0200
Message-Id: <1251097136.7538.124.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 16:54 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> arch/powerpc/kernel/perf_callchain.c: In function 'perf_callchain_kernel':
> arch/powerpc/kernel/perf_callchain.c:73: error: implicit declaration of function 'perf_paranoid_anon_ip'
> 
> Caused by commit 512cec5d6f2a71e04464bf4fd76a50571bd0dea1 ("perf_counter:
> powerpc: Support the anonimized kernel callchain bits") which I have
> reverted for today.

Yes, that needs to be gone, it relied on another change which never went
in. Ingo could you make that commit disappear?
