Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYAWQMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYAWQMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbYAWQF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:05:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60531 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbYAWQE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:04:56 -0500
Date: Wed, 23 Jan 2008 08:04:38 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: test case for the RODATA config option
Message-ID: <20080123080438.490b0c3e@laptopd505.fenrus.org>
In-Reply-To: <200801231627.28715.andi@firstfloor.org>
References: <20080122144420.4ebcf95f@laptopd505.fenrus.org>
	<p731w88nc0p.fsf@crumb.suse.de>
	<20080123064905.5d05509a@laptopd505.fenrus.org>
	<200801231627.28715.andi@firstfloor.org>
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

On Wed, 23 Jan 2008 16:27:28 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> 
> > What it does is check if the rodata marking was succesful.
> 
> The only difference I see is that you check that the TLB flush works,
> but for that it looks awfully incomplete.

you think one level too small.
It tests if mark_rodata_ro() operated correctly.
Yes internally that uses c-p-a, but there's more code there, including a set of boundary conditions etc.
And for the page table to work, cr0 needs to be set up correctly etc etc etc.


 
> Other than it is identical [modulo the kernel mapping bit on 64bit]--

it's a test of mark_rodata_ro(), not of c-p-a. Not the same thing.


> What I meant using the more extensive test in pageattr-test.c
> to test a few changes in the 64bit kernel mapping too, not moving your
> code. I don't think moving your code makes sense. Sorry for being
> unclear.

then I just don't get your comment at all; sorry.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
