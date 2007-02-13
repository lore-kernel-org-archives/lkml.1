Return-Path: <linux-kernel-owner+w=401wt.eu-S1751185AbXBMIXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbXBMIXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXBMIXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:23:31 -0500
Received: from ns.suse.de ([195.135.220.2]:49906 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbXBMIXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:23:30 -0500
Message-ID: <45D1757C.4080907@suse.de>
Date: Tue, 13 Feb 2007 09:23:24 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 3/3, resend] kbuild: correctly skip tilded backups in
 localversion files
References: <20070206011819.160359000@flower.upol.cz> <20070206012208.050237000@flower.upol.cz> <12c511ca0702121409t30e126dfh445d13dd2f637e08@mail.gmail.com> <Pine.LNX.4.64.0702121437420.8424@woody.linux-foundation.org> <20070213003258.GA15534@flower.upol.cz> <20070213050503.GA27441@flower.upol.cz>
In-Reply-To: <20070213050503.GA27441@flower.upol.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> I mean, all by-hand modifications must be in the $(srctree) (let's get
> this term), $(objtree) is output *only*. Thus, i would propose to remove
> it from the path. Even dynamic SCM mechanism of adding local version
> doesn't use `localversion' files.

I use localversion-$foo files in both srctree (scm tags such as
"-hg<changeset>") and objtree (config tag, "-default", "-pae", ...) and
find it quite useful.  The login prompt usually includes $(uname -r), so
you easily see what kernel the machine runs at the moment ...

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
