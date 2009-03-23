Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbZCWInN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbZCWInN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbZCWImw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:42:52 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43247 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327AbZCWImv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:42:51 -0400
Subject: Re: SLOB lockup (was: Re: [tip:core/locking] lockdep: annotate
	reclaim context (__GFP_NOFS), fix SLOB)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-tip-commits@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
In-Reply-To: <1237215129.3213.193.camel@calx>
References: <20090128135457.350751756@chello.nl>
	 <200903152006.21160.nickpiggin@yahoo.com.au>
	 <1237128960.3213.133.camel@calx>
	 <200903162100.30029.nickpiggin@yahoo.com.au>
	 <1237215129.3213.193.camel@calx>
Date: Mon, 23 Mar 2009 10:42:47 +0200
Message-Id: <1237797767.6313.35.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 09:52 -0500, Matt Mackall wrote:
> > Don't hold SLOB lock when freeing the page. Reduces lock hold width.
> > 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

Applied, thanks!

