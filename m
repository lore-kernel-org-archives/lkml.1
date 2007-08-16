Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbXHPNIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbXHPNIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXHPNIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:08:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58353 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753998AbXHPNIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:08:19 -0400
Date: Thu, 16 Aug 2007 12:26:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: david@lang.hm, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: [PATH 1/1] Kexec jump - v2 - kexec jump
Message-ID: <20070816102635.GA2039@elf.ucw.cz>
References: <1184483639.1898.99.camel@caritas-dev.intel.com> <20070731095101.GA1774@elf.ucw.cz> <1185954978.1363.23.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185954978.1363.23.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +int kexec_flags;
> > > +
> > > +static unsigned long kexec_jump_buf_pfn;
> > > +
> > > +static int __init parse_kexec_jump_buf_pfn(char *arg)
> > > +{
> > > +	if (!arg)
> > > +		return -EINVAL;
> > > +
> > > +	kexec_jump_buf_pfn = memparse(arg, &arg);
> > > +	kexec_flags |= KEXEC_FLAGS_IS_KEXECED_KERNEL;
> > > +	return 0;
> > > +}
> > > +early_param("kexec_jump_buf_pfn", parse_kexec_jump_buf_pfn);
> > 
> > This one should be documented, too, I'd guess. (Is that internal,
> > kernel-to-kernel communication?)
> 
> Document will be added in next version too.

Ping... is there some next version?

I'm stuck at the tools side currently. kexec-1.101 just won't load the
kernel properly, and kexec-testing from git does not know -j option. I
tried hand-patching it, but got lots of scary rejects.

Is there chance for a patch against kexec-testing?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
