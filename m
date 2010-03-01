Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab0CAJTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:19:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37800 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab0CAJTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:19:44 -0500
Date: Mon, 1 Mar 2010 10:19:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Greg KH <greg@kroah.com>, "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Sage Weil <sage@newdream.net>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Al Viro <viro@ZenIV.linux.org.uk>, J??rn Engel <joern@logfs.org>
Subject: Re: linux-next: current pending merge fix patches
Message-ID: <20100301091916.GA30098@elte.hu>
References: <20100301160445.5e281f11.sfr@canb.auug.org.au>
 <20100301081021.GB8049@elte.hu>
 <20100301085613.GA2867@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301085613.GA2867@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > So i'd argue to not backmerge during the merge window (and i have stopped 
> > doing that myself a few cycles ago, and it clearly helped things) - but in 
> > any case it's certainly no big deal and up to Linus i guess.
> 
> What i do instead is that once Linus pulls from me i pull back immediately 
> to test, and if it's fine i base further subsystem patches on that and test 
> the heck out of the combination from that point on.

A sidenote: this is only advisable if the testing in the subsystem tree is 
strong, if there were many changes with interactions and if Linus's tree is 
still in its stable phase (like now).

For slower-pace subsystems it's often good to be even more conservative with 
backmerges: to wait until -rc1 with any backmerges and to to generally not 
backmerge non-rc-release versions of Linus's tree.

That way the development commits and the followup fix commits stay in one 
linear branch of history, with no backmerge inbetween, easily bisectable and 
testable on a stable base all the way.

Thanks,

	Ingo
