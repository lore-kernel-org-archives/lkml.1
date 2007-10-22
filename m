Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbXJVAr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbXJVAr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 20:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXJVArx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 20:47:53 -0400
Received: from xenotime.net ([66.160.160.81]:59542 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751164AbXJVArw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 20:47:52 -0400
Date: Sun, 21 Oct 2007 17:47:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Henrik Carlqvist <hc1@poolhem.se>, linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
Message-Id: <20071021174748.92abc989.rdunlap@xenotime.net>
In-Reply-To: <20071021210313.GA6725@uranus.ravnborg.org>
References: <200710201257.55616.nick@ukfsn.org>
	<20071020144238.4f258c8c.hc1@poolhem.se>
	<20071020191700.GB8774@uranus.ravnborg.org>
	<26703.1192942058@turing-police.cc.vt.edu>
	<20071021122402.2f0f3b40.hc1@poolhem.se>
	<20071021094517.78dd1916.rdunlap@xenotime.net>
	<20071021210313.GA6725@uranus.ravnborg.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 23:03:13 +0200 Sam Ravnborg wrote:

> On Sun, Oct 21, 2007 at 09:45:17AM -0700, Randy Dunlap wrote:
> > > Is there any other way to specify that a functionality can only be built
> > > as a module, not built into the kernel?
> > 
> > config FOO
> > 	depends on BAR && m
> > 
> > restricts FOO to module-only.
> > 
> > > In my firsta attempts to post about these tests my post ended up not on
> > > the mailing list but as a reply to Sam Ravnborg only, apologies for
> > > that...
> 
> This is obviously the right solution.
> Randy - we should document this somewhere together with more kconfig tips'n'tricks.

Agreed.

> A new document or do we extend kconfig-language?

I don't see a need for a separate document.  I would just extend
kconfig-language.

---
~Randy
