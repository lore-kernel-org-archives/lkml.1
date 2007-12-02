Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbXLBWp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbXLBWp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 17:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbXLBWpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 17:45:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37732 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXLBWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 17:45:20 -0500
Date: Sun, 2 Dec 2007 14:43:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202144331.6abf1289@laptopd505.fenrus.org>
In-Reply-To: <20071202204725.GA25891@one.firstfloor.org>
References: <20071201092037.GA32544@elte.hu>
	<p737ijwylet.fsf@bingen.suse.de>
	<20071202185945.GA25990@elte.hu>
	<20071202114152.3bf4332d@laptopd505.fenrus.org>
	<20071202200953.GA23994@one.firstfloor.org>
	<20071202202602.GA16480@elte.hu>
	<20071202204725.GA25891@one.firstfloor.org>
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

On Sun, 2 Dec 2007 21:47:25 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > Out of direct experience, 95% of the "too long delay" cases are
> > plain old bugs. The rest we can (and must!) convert to
> > TASK_KILLABLE or could 
> 
> I already pointed out a few cases (nfs, cifs, smbfs, ncpfs, afs).   
> It would be pretty bad to merge this patch without converting them to 
> TASK_KILLABLE first

"pretty bad" as in "a few people see warnings in their dmesg" ?
And TASK_KILLABLE is hopefully about to get merged anyway.


We really need to get better diagnostics for the
bad-kernel-behavior-that-is-seen-as-bug cases. If we ever want to get
to the scenario where we have a more or less robust measure of kernel
quality (and we're not all that far off for several cases), one thing
we need keep doing is have the kernel detect bad cases as much as
possible. This patch is a step in the right direction there, by quite a
lot.

I really don't understand what your objection is to this patch... is it
that an enterprise distro can't ship with it on? (Which is fine btw)

> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
