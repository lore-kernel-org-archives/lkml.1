Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYGJORT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYGJORT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYGJORG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:17:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:47146 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbYGJORF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:17:05 -0400
Date: Thu, 10 Jul 2008 07:16:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
Message-ID: <20080710071640.5035cd70@infradead.org>
In-Reply-To: <200807092015.03004.yhlu.kernel@gmail.com>
References: <200807080141.05436.yhlu.kernel@gmail.com>
	<200807080143.27997.yhlu.kernel@gmail.com>
	<200807092015.03004.yhlu.kernel@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 20:15:02 -0700
Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> 
> 
> fix phys_pmd_init to make sure not to return big value than end.
> 
> also print out range split:1G/2M/4K
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>


Making an accurate mapping solves a lot of potentially nasty/tricky
corner cases, so I like the approach

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
