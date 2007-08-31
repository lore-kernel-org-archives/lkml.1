Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbXHaOhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbXHaOhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbXHaOhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:37:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40824 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbXHaOhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:37:09 -0400
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs-oss <xfs@oss.sgi.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <46D826BA.1060705@sandeen.net>
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins>
	 <20070831135042.GD422459@sgi.com>  <46D826BA.1060705@sandeen.net>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 16:36:52 +0200
Message-Id: <1188571012.6112.67.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 09:33 -0500, Eric Sandeen wrote:

> Peter, unless there is some other reason to do so, changing xfs
> performance behavior simply to satisfy lockdep limitations* doesn't seem
> like the best plan.
> 
> I suppose one slightly flakey option would be for xfs to see whether
> lockdep is enabled and adjust cluster size based on MAX_LOCK_DEPTH... on
> the argument that lockdep is likely used in debugging kernels where
> sheer performance is less important... but, that sounds pretty flakey to me.

Agreed, that sucks too :-/

I was hoping there would be a 'nice' solution, a well, again, reality
ruins it.

