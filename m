Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbXJIEzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbXJIEzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 00:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbXJIEzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 00:55:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53022 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbXJIEy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 00:54:59 -0400
Date: Mon, 8 Oct 2007 21:53:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Oleg Verych <olecom@flower.upol.cz>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-Id: <20071008215316.6e186b89.randy.dunlap@oracle.com>
In-Reply-To: <20071009041743.GA21552@uranus.ravnborg.org>
References: <20071008200255.GA16497@uranus.ravnborg.org>
	<20071008205048.GY22435@flower.upol.cz>
	<20071009041743.GA21552@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007 06:17:43 +0200 Sam Ravnborg wrote:

> > 
> > What about, that this is the first ever prompt, that must be shown and
> > written to the .config?
> Two issues to fix before we can do this:
> 1) chocie values cannot have more than one prompt
> 2) We need to share much more Kconfig* between the individual architectures
>    First step is to let all arch's use drivers/Kconfig

2) isn't terribly difficult, just takes some time and willingness
of $arch maintainers to some changes, but please explain a bit more
why it is needed...?


> Let's get the two items above solved then we can revisit adding arch selection
> to kconfig (where it belongs in the end).
> And neither require a rewrite of kconfig...
> 
> > Also, i'd like to propose sequencing of config-enable-build-this-unit
> > in config file(s), thus Makefile(s) (sometimes very small and stupid)
> > will be not necessary. Additional link ordering can be supplied as
> > meta-config information there. Shell scripting, very ugly in the view
> > of make syntax, will be natural in config files. Extending build
> > process to get hidden dependencies or right linking/other magic is
> > part of particular configuration. Hm?
> Discussed before but so far no patches has shown up.


---
~Randy
