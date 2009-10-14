Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZJNRgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZJNRgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZJNRgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:36:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39521 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbZJNRgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:36:31 -0400
Date: Wed, 14 Oct 2009 13:35:53 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: Re: [patch 25/28] parisc: Remove BKL from eisa_eeprom
Message-ID: <20091014173552.GO11702@bombadil.infradead.org>
References: <20091010153314.827301943@linutronix.de> <20091010153350.086917493@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010153350.086917493@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 03:37:26PM -0000, Thomas Gleixner wrote:
> Remove the empty ioctl and the cycle_kernel_lock() in
> eisa_eeprom_open() which got there with the big BKL push down. There
> is nothing to wait for and sychronize with after the misc device has
> been registered.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kyle McMartin <kyle@parisc-linux.org>

Looks good to me.

Acked-by: Kyle McMartin <kyle@mcmartin.ca>
