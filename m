Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZKJMkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZKJMkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZKJMkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:40:41 -0500
Received: from ns.firmix.at ([62.141.48.66]:1139 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbZKJMkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:40:40 -0500
Subject: Re: FatELF patches...
From: Bernd Petrovitsch <bernd@firmix.at>
To: weigelt@metux.de
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091110112737.GB2998@nibiru.local>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	 <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	 <alpine.OSX.1.10.0911011540400.53392@caridad.local>
	 <20091102000147.424f104b@lxorguk.ukuu.org.uk>
	 <alpine.OSX.1.10.0911021057450.464@caridad.icculuslan>
	 <20091110112737.GB2998@nibiru.local>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 10 Nov 2009 13:40:25 +0100
Message-Id: <1257856825.795.20.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.67 on ns.firmix.at
X-Firmix-Spam-Score: -2.285 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.285 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Tue, 10 Nov 2009 13:40:45 CET
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 12:27 +0100, Enrico Weigelt wrote:
> * Ryan C. Gordon <icculus@icculus.org> wrote:
[...] 
> > True. If I try to run a PowerPC binary on a Sparc, it fails in any 
> > circumstance. I recognize the goal of this post was to shoot down every 
If tools like qemu support PowerPC or Sparc (similar to some dialects of
ARM), you your run it through that (on every hardware where qemu as such
runs[0]).
And if you have bimfmt_misc, you can start it like any other "native"
program.

> > single point, but you can't see a scenario where this adds a benefit? Even 
> > in a world that's still running 32-bit web browsers on _every major 
> > operating system_ because some crucial plugins aren't 64-bit yet?
>
> The root of evil are plugins - even worse: binary-only plugins.
> 
> Let's just take browsers: is there any damn good reason for not putting
> those things into their own process (9P provides a fine IPC for that),
> besides stupidity and lazyness of certain devs (yes, this explicitly
> includes mozilla guys) ?
Or implement running 32bit plugins from a 64bit browser.

[...]  
> > > - Prepare your app on a USB stick for sneakernet, know it'll work on
> > >   whatever Linux box you are likely to plug it into.
Trojan horse deployers paradise BTW.

[....]
> > It's possible to ship binaries that don't depend on a specific 
> > distribution, or preinstalled dependencies, beyond the existance of a 
> > glibc that was built in the last five years or so. I do it every day. It's 
ACK, just link it statically and be done (but then you have other
problems, e.g. "$LIB has an exploit and I have to rebuild and redeploy
$BINARY").

[...]
> > That is anecdotal, and I apologize for that. But I'm not the only 
> > developer that's not in an apt repository, and all of these rebuttals are 
> > anecdotal: "I just use yum [...because I don't personally care about 
> > Debian users]."
It's not that the other way around is much of a difference:-(
And if there is some really interested Debian user, he can package it
for Debian.
IMHO better no package for $DISTRIBUTION than only bad (and old) ones
because some packager (which is not necessarily a core programmer) has
only very little personal interest in the .deb version.

> Can't just just make up your own repo ? Is it so hard ?
> Just can speak for Gentoo - overlays are quite convenient here.
And it's not that hard to write .spec files for RPM (for average
packages - e.g. the kernel and gcc is somewhat different). Just take a
small one (e.g. the one from "trace") and start from there.
SCNR,
	Bernd

[09: I never tried to cascade qemu though.
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


