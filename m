Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbZAEQTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbZAEQTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZAEQTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:19:13 -0500
Received: from ns.firmix.at ([62.141.48.66]:5467 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZAEQTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:19:12 -0500
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with
	kernel/timeconst.sh
From: Bernd Petrovitsch <bernd@firmix.at>
To: Jamie Lokier <jamie@shareable.org>
Cc: Rob Landley <rob@landley.net>, Valdis.Kletnieks@vt.edu,
       Ingo Oeser <ioe-lkml@rameria.de>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20090105150156.GD14503@shareable.org>
References: <200901020207.30359.rob@landley.net>
	 <200901031936.04642.rob@landley.net>
	 <25035.1231045675@turing-police.cc.vt.edu>
	 <200901040043.08577.rob@landley.net> <20090104221356.GA32357@shareable.org>
	 <1231114530.3310.6.camel@gimli.at.home>
	 <20090105022349.GB1345@shareable.org>
	 <1231152378.3326.14.camel@gimli.at.home>
	 <20090105150156.GD14503@shareable.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Mon, 05 Jan 2009 17:18:00 +0100
Message-Id: <1231172280.3326.138.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.1 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-1.1 required=5
X-Spam-Score: -1.1 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 15:01 +0000, Jamie Lokier wrote:
> Bernd Petrovitsch wrote:
> > I assume that the NFS-mounted root filesystem is a real distribution.
> 
> Not unless you call uClinux (MMU-less) a real distribution, no.

Not really.

> > > (* - No MMU on some ARMs, but I'm working on ARM FDPIC-ELF to add
> > >      proper shared libs.  Feel free to fund this :-)
> > 
> > The above mentioned ARMs have a MMU. Without MMU, it would be truly
> > insane IMHO.
> 
> We have similar cross-build issues without MMUs... I.e. that a lot of

Of course.

> useful packages don't cross-build properly (including many which use
> Autoconf), and it might be easier to make a native build environment

Tell me about it - AC_TRY_RUN() is the culprit.
And `pkg-config` supports cross-compilation only since 18 months or so.
Before one had to rewrite the generated .pc files.

[...]
> You mentioned ARM Debian.  According to
> http://wiki.debian.org/ArmEabiPort one recommended method of
> bootstrapping it is building natively on an emulated ARM, because
> cross-building is fragile.

That's of course the other solution - if qemu supports your
$EMBEDDED_CPU good enough.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

