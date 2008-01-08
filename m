Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYAHR2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYAHR2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYAHR2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:28:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49535 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbYAHR2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:28:36 -0500
Date: Tue, 8 Jan 2008 09:28:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch 2/2] Use the stack frames to get exact stack-traces for
 CONFIG_FRAMEPOINTER on x86-64
Message-ID: <20080108092816.47848920@laptopd505.fenrus.org>
In-Reply-To: <p73fxx8qmir.fsf@bingen.suse.de>
References: <20080107211437.5ba42f18@laptopd505.fenrus.org>
	<p73fxx8qmir.fsf@bingen.suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jan 2008 18:01:48 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> 
> > The code tries to use the frame pointers to do a backtrace, but if
> > it smells iffy or invalid, falls back to the traditional way of
> > printing backtraces, to make sure that at least some useful
> > backtrace is created.
> 
> That will likely happen in most non trivial cases
> (interrupts/exceptions etc.)

interrupts at least work just fine... I tested that already



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
