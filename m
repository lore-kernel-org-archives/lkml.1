Return-Path: <linux-kernel-owner+w=401wt.eu-S1762941AbYHDU71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762941AbYHDU71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbYHDU7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:59:20 -0400
Received: from mail.fieldses.org ([66.93.2.214]:38674 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbYHDU7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:59:19 -0400
Date: Mon, 4 Aug 2008 16:59:08 -0400
To: Paul Collins <paul@burly.ondioline.org>
Cc: michael@ellerman.id.au, Neil Brown <neilb@suse.de>,
       linuxppc-dev@ozlabs.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux,
	post-2.6.27-rc1
Message-ID: <20080804205908.GA29890@fieldses.org>
References: <20080802184554.GB715@fieldses.org> <87abfvm4cc.fsf@burly.wgtn.ondioline.org> <877iayy4qc.fsf@burly.wgtn.ondioline.org> <18581.40960.737792.454035@notabene.brown> <87r696l1yo.fsf@burly.wgtn.ondioline.org> <18582.32935.501672.689845@notabene.brown> <87fxpll5zq.fsf@burly.wgtn.ondioline.org> <87y73dcd60.fsf@burly.wgtn.ondioline.org> <1217860597.12535.2.camel@localhost> <87hca05ws4.fsf@burly.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hca05ws4.fsf@burly.wgtn.ondioline.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 08:51:23AM +1200, Paul Collins wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
> 
> > On Mon, 2008-08-04 at 22:00 +1200, Paul Collins wrote:
> >> Paul Collins <paul@burly.ondioline.org> writes:
> >> 
> >> > Neil Brown <neilb@suse.de> writes:
> >> >> Could you try removing the 'static' declaration for nfsd_acceptable
> >> >> and recompile?
> >> >> Or maybe try a different compiler?
> >> >
> >> > I will give these a try this evening.
> >> 
> >> I built myself a nice new cross compiler:
> >> 
> >>         powerpc-linux-gnu-gcc-4.1 (GCC) 4.1.3 20080623 (prerelease) (Debian 4.1.2-23)
> >> 
> >> and rebuilt 94ad374a0751f40d25e22e036c37f7263569d24c.  Running that on
> >> the server and 2.6.26 on the client, I got yet another Oops.  This one
> >> locked the machine up pretty good, so all I have is a picture:
> >> 
> >> http://ondioline.org/~paul/DSCN1608.JPG
> >
> > Wow.
> >
> > Can you try building a kernel on the server? ie. not over NFS.
> 
> Built kernels on the server with native gcc 4.2.4 and 4.3.1 and repeated
> the build test.
 
But the build test itself was over nfs?  (And you can't reproduce the
same problem without nfs?)

--b.

> Both of them threw an Oops with traces like the ones
> we've seen before.  Also, because now's about time to start shooting in
> the dark, I tried a cross-built kernel with CC_OPTIMIZE_FOR_SIZE
> disabled.  That one Oopses too.  Also I reseated the server's memory.
> 
> Although I've been able to build kernels over NFS with 2.6.26 on the
> server, I've just realized I haven't tried to stress it much.  I'll try
> a build loop when the server's running 2.6.26 this evening.
> 
> -- 
> Paul Collins
> Wellington, New Zealand
> 
> Dag vijandelijk luchtschip de huismeester is dood
