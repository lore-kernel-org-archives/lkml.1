Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbYDIRRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbYDIRRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYDIRRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:17:06 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58583 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbYDIRRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:17:04 -0400
Date: Wed, 9 Apr 2008 20:22:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] set_restore_sigmask TIF_SIGPENDING
Message-ID: <20080409162206.GA764@tv-sign.ru>
References: <20080329001230.D013726FA1D@magilla.localdomain> <20080329001341.7F93826FA1D@magilla.localdomain> <alpine.LFD.1.00.0803281746480.14670@woody.linux-foundation.org> <20080408113519.GA227@tv-sign.ru> <1207739787.27048.57.camel@shinybook.infradead.org> <20080409113939.GA99@tv-sign.ru> <1207757653.27048.77.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207757653.27048.77.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, David Woodhouse wrote:
>
> One of the supposed advantages of TIF_RESTORE_SIGMASK in the first
> place, iirc, was that it allowed us to return a result code other than
> -EINTR as _well_ as restoring the signal mask.

Agreed, good point. ERESTART_ is not that flexible.

Somehow I assumed we will never need something "special" here, this is
not very clever.

Thanks to all!

Oleg.

