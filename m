Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbYC1NSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbYC1NSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYC1NSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:18:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38139 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYC1NSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:18:07 -0400
Date: Fri, 28 Mar 2008 07:17:50 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: down_spin() implementation
Message-ID: <20080328131750.GT16721@parisc-linux.org>
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com> <20080326123239.GG16721@parisc-linux.org> <1FE6DD409037234FAB833C420AA843ECE9EB1C@orsmsx424.amr.corp.intel.com> <20080327141508.GL16721@parisc-linux.org> <20080328125104.GK12346@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328125104.GK12346@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 01:51:04PM +0100, Jens Axboe wrote:
> It used to be illegal to pass flags as parameters. IIRC, sparc did some
> trickery with it. That may still be the case, I haven't checked in a
> long time.

That problem was removed before 2.6 started, iirc.  At least the chapter
on 'The Fucked Up Sparc' [1] was removed before 2.6.12-rc2 (the
beginning of git history and I can't be bothered to pinpoint it more
precisely).

> Why not just fold __down_spin() into down_spin() and get rid of that
> nasty anyway?

Could have done.  It's moot now that Nick's pointed out how unsafe it
is to mix down_spin() with plain down().

[1] http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/x467.html

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
