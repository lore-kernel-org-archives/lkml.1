Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYAWFaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYAWFaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 00:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYAWFaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 00:30:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56617 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYAWF37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 00:29:59 -0500
Date: Tue, 22 Jan 2008 21:29:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: test case for the RODATA config option
Message-ID: <20080122212944.34bbf2bd@laptopd505.fenrus.org>
In-Reply-To: <200801231211.41750.nickpiggin@yahoo.com.au>
References: <20080122144420.4ebcf95f@laptopd505.fenrus.org>
	<200801231211.41750.nickpiggin@yahoo.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008 12:11:41 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> >  #ifdef CONFIG_DEBUG_RODATA
> >
> > +const int rodata_test_data = 5;
> 
> I guess this should match the 32-bit case, and be zero instead of
> 5?

actually it should have been 5 for both (well any non-zero number)
> 
> Can you disallow building as a module, and put this in the test
> code? It could be run from the end of mark_rodata_ro()...

fair; I was developing it as a module (just easier) but yeah it makes more sense as part
of mark_rodata_ro(). I'll do that in the next rev


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
