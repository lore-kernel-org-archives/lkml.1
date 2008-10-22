Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbYJVTFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbYJVTFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYJVTF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:05:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53144 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYJVTF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:05:28 -0400
Date: Wed, 22 Oct 2008 13:05:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Tesarik <ptesarik@suse.cz>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tee@sgi.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Allow rwlocks to re-enable interrupts
Message-ID: <20081022190510.GH26094@parisc-linux.org>
References: <1224664414.4430.33.camel@elijah.suse.cz> <1224664476.4430.38.camel@elijah.suse.cz> <1224665128.15448.4.camel@twins> <1224665899.4430.48.camel@elijah.suse.cz> <1224696271.20069.8.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224696271.20069.8.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 07:24:31PM +0200, Peter Zijlstra wrote:
> > No problem. I could then also use it for _spin_lock_irqsave, if the
> > answer to the above question is use CONFIG_LOCK_STAT there as well.
> 
> If you create LOCK_CONTEDED_FLAGS() the whole issue goes away nicely.

Should it also be used for _spin_lock_irq()?  I'm puzzled why it's only
used for _irqsave().

(should _spin_lock_bh() re-enable BHs while waiting?  Is it just not big
enough of a deal?)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
