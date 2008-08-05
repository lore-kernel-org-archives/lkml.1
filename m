Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYHEJnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYHEJnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbYHEJnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:43:39 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:35747 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbYHEJni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:43:38 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: michael@ellerman.id.au
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       linuxppc-dev@ozlabs.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux, post-2.6.27-rc1
References: <20080802184554.GB715@fieldses.org>
	<87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	<877iayy4qc.fsf@burly.wgtn.ondioline.org>
	<18581.40960.737792.454035@notabene.brown>
	<87r696l1yo.fsf@burly.wgtn.ondioline.org>
	<18582.32935.501672.689845@notabene.brown>
	<87fxpll5zq.fsf@burly.wgtn.ondioline.org>
	<87y73dcd60.fsf@burly.wgtn.ondioline.org>
	<1217860597.12535.2.camel@localhost>
	<87hca05ws4.fsf@burly.wgtn.ondioline.org>
	<20080804205908.GA29890@fieldses.org>
	<1217895418.7951.7.camel@localhost>
	<8763qg5don.fsf@burly.wgtn.ondioline.org>
	<1217910862.7951.22.camel@localhost>
Date: Tue, 05 Aug 2008 21:43:37 +1200
In-Reply-To: <1217910862.7951.22.camel@localhost> (Michael Ellerman's message
	of "Tue, 05 Aug 2008 04:34:22 +0000")
Message-ID: <87zlnrer06.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> I see you have FTRACE enabled. That's new and could potentially bugger
> things up without the compiler knowing, so can you turn that off.

With FTRACE disabled, doing cross-builds from the 2.6.26 amd64 client, a
setup that normally triggers the problem on the 2nd or 3rd build, I was
able to do 10 complete builds.  ("make clean oldconfig vmlinux modules")

So it looks like ftrace is the cause, or at least provokes some other
usually-latent problem.  I wasn't using it, so I'll just leave it off.

> And can you enable CONFIG_CODE_PATCHING_SELFTEST and
> CONFIG_FTR_FIXUP_SELFTEST, that will enable tests of some code I changed
> that /could/ (maybe) cause random blow ups.

With those options enabled, I get this:

  Running code patching self-tests ...
  Running feature fixup self-tests ...

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
