Return-Path: <linux-kernel-owner+w=401wt.eu-S964804AbXCNXTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbXCNXTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 19:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964806AbXCNXTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 19:19:38 -0400
Received: from kanga.kvack.org ([66.96.29.28]:47935 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964804AbXCNXTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 19:19:37 -0400
Date: Wed, 14 Mar 2007 19:19:20 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 13/13] signalfd/timerfd/asyncfd v5 - KAIO asyncfd support (example/maybe-broken) ...
Message-ID: <20070314231920.GB1246@kvack.org>
References: <send-serie.davidel@xmailserver.org.13805.1173910770.13>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <send-serie.davidel@xmailserver.org.13805.1173910770.13>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 03:19:21PM -0700, Davide Libenzi wrote:
> +	/*
> +	 * Check if the user asked us to deliver the result through an
> +	 * asyncfd. Note that asyncfd_add_results() may sleep. It seems
> +	 * OK looking at the code, but I'm not sure since inside a USB driver,
> +	 * aio_complete() is called with a spinlock held. !!CHECK
> +	 */

That won't work.  aio_complete() is supposed to be irq safe.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
