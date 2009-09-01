Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbZIAGdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbZIAGdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 02:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZIAGdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 02:33:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:43557 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZIAGdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 02:33:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,311,1249282800"; 
   d="scan'208";a="546579043"
Subject: Re: memleaks, acpi + ext4 + tty
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Eric Paris <eparis@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Eric Paris <eparis@parisplace.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "H. Peter Anvin" <hpa@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890908311731h626a5b9bu486653c755cda2fa@mail.gmail.com>
References: <tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com>
	 <43e72e890908311050s320d0ceen312a0d3d9e4fbc76@mail.gmail.com>
	 <43e72e890908311137k78ac439bs4edf376d07343a32@mail.gmail.com>
	 <43e72e890908311230u28b0642ep7a6bfd9dab82318a@mail.gmail.com>
	 <20090831193345.GG5631@tuxdriver.com>
	 <43e72e890908311243u50b9323fveda9feaaa4d8efdb@mail.gmail.com>
	 <20090831194753.GH5631@tuxdriver.com>
	 <43e72e890908311302s58743978wd8950f167a871cfb@mail.gmail.com>
	 <43e72e890908311654t5d9489d3w9a817cffab5cb8f8@mail.gmail.com>
	 <1251764791.2158.7.camel@dhcp231-106.rdu.redhat.com>
	 <43e72e890908311731h626a5b9bu486653c755cda2fa@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 14:33:49 +0800
Message-Id: <1251786829.8830.277.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 08:31 +0800, Luis R. Rodriguez wrote:
> >>
> http://git.infradead.org/users/eparis/notify.git/commit/b962e7312ae87006aed6f68ceee94bdf8db08338
> >>
> >> FWIW for that patch:
> >>
> >> Tested-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> >>
> >> So -- you if you're like me and had issues with bootup lag on
> >> wireless-testing, you can probably fix your wireless-testing by
> >> pulling his patches:
> >>
> >> git pull git://git.infradead.org/users/eparis/notify.git for-linus
> >>
> >> I saw Linus had some other fixes but I'll wait for rc9 for that as
> my
> >> box seems reasonably stable right now.
> >
> > Yes, -rc8 broke pretty badly for a number of people.  Linus did pull
> all
> > of the fixes that I know of.  I wouldn't suggest pulling just that
> one
> > commit.  All 3 of the post -rc8 patches in my tree fix -rc8
> > regressions   :(
> 
> Thanks, the note -- so I guess best is to just pull from Linus ontop
> of wireless-testing.

I confirm I'm also suffered with the problem on today's wireless-testing
tip (udevadm --settle hangs on boot) and the above patch does fix the
issue for me. Thanks both for identify and fix the problem.

Thanks,
-yi

