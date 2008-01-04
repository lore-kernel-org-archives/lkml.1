Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYADOkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYADOkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 09:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYADOjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 09:39:54 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:34552 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbYADOjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:39:53 -0500
Date: Fri, 4 Jan 2008 15:39:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild update
Message-ID: <20080104143953.GA30536@uranus.ravnborg.org>
References: <20080103213255.GA21811@uranus.ravnborg.org> <20080104132316.GA2485@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104132316.GA2485@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 09:23:16PM +0800, WANG Cong wrote:
> 
> {snip}
> 
> >TODO items (from my mailbox - I have plenty more)
> >=================================================
> >- asm-offset useable from modules (Oleg had a half backed solution)
> >- modpost should use err(), warn() etc (suggestyed by Rusty)
> >- less kernel hardcoding in kconfig (Rob Landley)
> >- emit dependencies from "depends" (Bernhard Fischer)
> >- fix select (whatever that means)
> >- allow kconfig to accept overrides (Jan Engelhart)
> >  maybe there is a patch, needs followup
> >- document kernel build better (Andreas Hermann)
> >  just a start, more is needed
> >- save ARCH and CROSSCOMPILE
> >  requires major surgery to do correct - we use CC too early
> >- i18n patch for mconf and friends (from Kernel Translator project)
> >  is old but several bits of it needs to be applied to better support i18n
> 
> Hmm, I glanced at that project. It's old and seems freezed now.
> I don't know if people still have interests in the i18n of kconfig.
> If so, I think I can help with the Chinese part. ;)

>From the off-list communication I have had there is indeed an interest.
It sort of stopped at one point due to missing integration in mainline.
What I refer to is mostly the mconf.c bits, but I would also like to
see what lkml says to a sample of .po files included in the kernel
for a number of languages.

One criteria to get a .po file integrated could be at least 10% of the
strings translated or similar.

	Sam
