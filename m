Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbZCLKPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbZCLKPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbZCLKPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:15:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:49649 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZCLKPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:15:36 -0400
Subject: Re: [PATCH 6/6] futex: cleanup fault logic
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20090312075612.9856.48612.stgit@Aeon>
References: <20090312075349.9856.83687.stgit@Aeon>
	 <20090312075612.9856.48612.stgit@Aeon>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 11:15:22 +0100
Message-Id: <1236852922.5090.121.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 00:56 -0700, Darren Hart wrote:
> Older versions of the futex code held the mmap_sem which had to be
> dropped in order to call get_user(), so a two-pronged fault handling
> mechanism was employed to handle faults of the atomic operations.  The
> mmap_sem is no longer held, so get_user() should be adequate.  This patch
> greatly simplifies the logic and improves legibility.

Thanks!

