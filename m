Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYF0U4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYF0U4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbYF0U42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:56:28 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57512 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbYF0U40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:56:26 -0400
Date: Fri, 27 Jun 2008 22:57:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, torvalds@linux-foundation.org,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Subject: Re: [PATCH] Fix a.out.h export to userspace with O= build.
Message-ID: <20080627205712.GA29202@uranus.ravnborg.org>
References: <20080627130236.GD18644@cs181140183.pp.htv.fi> <1214571984.10393.193.camel@pmac.infradead.org> <20080627131231.GF18644@cs181140183.pp.htv.fi> <1214573982.10393.204.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214573982.10393.204.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 02:39:42PM +0100, David Woodhouse wrote:
> On Fri, 2008-06-27 at 16:12 +0300, Adrian Bunk wrote:
> > On Fri, Jun 27, 2008 at 02:06:24PM +0100, David Woodhouse wrote:
> > > On Fri, 2008-06-27 at 16:02 +0300, Adrian Bunk wrote:
> > > > Commit e53d6a152793a38aa334d6f7a4850642ae45cedc
> > > > (Export <linux/a.out.h> to userspace again.)
> > > > does not work properly when using O= :
> > > 
> > > Hm, I copied the logic from the existing condition in
> > > include/asm-generic/Kbuild.asm. Does that not work either?
> > 
> > It doesn't work:
> > 
> > linux-2.6.26-rc8$ make O=../out headers_install
> > ...
> > linux-2.6.26-rc8$ find ../out -name a.out.h
> 
> You're right; it doesn't work with O=, and hasn't since David Howells
> first added that conditional export in commit 7fa30315. This fixes it:
> 
> ---
> From: David Woodhouse <david.woodhouse@intel.com>
> Subject: Fix a.out.h export to userspace with O= build.

Hi David.

Will you carry this patch in your tree or do you
want me to add it to kbuild-next.git?

	Sam
