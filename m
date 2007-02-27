Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbXB0AdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbXB0AdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbXB0AdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:33:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57900 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXB0AdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:33:20 -0500
Date: Tue, 27 Feb 2007 00:33:13 +0000
From: Christoph Hellwig <hch@infradead.org>
To: inaky@linux.intel.com
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@redhat.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] semaphores: add down_interruptible_timeout() and asm-generic/semaphore.h
Message-ID: <20070227003313.GA7360@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	inaky@linux.intel.com, Arjan van de Ven <arjan@infradead.org>,
	mingo@redhat.com, akpm@osdl.org, linux-kernel@vger.kernel.org
References: <20070227001338.344233745@sodium.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227001338.344233745@sodium.jf.intel.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 04:13:38PM -0800, inaky@linux.intel.com wrote:
> Introduce down_interruptible_timeout() using timers to make the waiter
> stop waiting by simulating a signal (see first patch for more
> details). As well introduce asm-generic/semaphore.h and make other
> architectures use it too.

What do you want this for?  Do you really need a full counting semaphore
or do you actually want a mutex?

