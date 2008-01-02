Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYABTY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYABTY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYABTYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:24:19 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:35196 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbYABTYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:24:18 -0500
Date: Wed, 2 Jan 2008 20:24:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andreas Schwab <schwab@suse.de>, Ralf Baechle <ralf@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-mips@linux-mips.org
Subject: Re: (Try #3) [Patch 2/8] MIPS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080102192416.GB11217@uranus.ravnborg.org>
References: <20080101071311.GA2496@hacking> <20080101072238.GC2496@hacking> <20080101101540.GB28913@uranus.ravnborg.org> <jefxxhlkxb.fsf@sykes.suse.de> <20080101175754.GC31575@uranus.ravnborg.org> <20080102062135.GE2493@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102062135.GE2493@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 02:21:36PM +0800, WANG Cong wrote:
> 
> >> 
> >> Shouldn't that use $(LINUXINCLUDE), or $(KBUILD_CPPFLAGS)?
> >It would be better to use $(LINUXINCLUDE) as we then pull in all config
> >symbols too and do not have to hardcode kbuild internal names (include2).
> 
> OK. Refine this patch.
> 
> ----------->
> 
> Since TOPDIR is obsolete, this patch removes TOPDIR
> from the Mips Makefiles.
> 
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
Applied.

	Sam
