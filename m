Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbXJIEQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbXJIEQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 00:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbXJIEQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 00:16:21 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59981 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbXJIEQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 00:16:20 -0400
Date: Tue, 9 Oct 2007 06:17:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-ID: <20071009041743.GA21552@uranus.ravnborg.org>
References: <20071008200255.GA16497@uranus.ravnborg.org> <20071008205048.GY22435@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008205048.GY22435@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> What about, that this is the first ever prompt, that must be shown and
> written to the .config?
Two issues to fix before we can do this:
1) chocie values cannot have more than one prompt
2) We need to share much more Kconfig* between the individual architectures
   First step is to let all arch's use drivers/Kconfig

Let's get the two items above solved then we can revisit adding arch selection
to kconfig (where it belongs in the end).
And neither require a rewrite of kconfig...

> Also, i'd like to propose sequencing of config-enable-build-this-unit
> in config file(s), thus Makefile(s) (sometimes very small and stupid)
> will be not necessary. Additional link ordering can be supplied as
> meta-config information there. Shell scripting, very ugly in the view
> of make syntax, will be natural in config files. Extending build
> process to get hidden dependencies or right linking/other magic is
> part of particular configuration. Hm?
Discussed before but so far no patches has shown up.

	Sam
