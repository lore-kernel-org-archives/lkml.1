Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXJIGCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXJIGCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 02:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXJIGCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 02:02:05 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36813 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbXJIGCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 02:02:04 -0400
Date: Tue, 9 Oct 2007 08:03:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Message-ID: <20071009060333.GB22087@uranus.ravnborg.org>
References: <20071008200255.GA16497@uranus.ravnborg.org> <20071008211255.GP16424@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008211255.GP16424@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 11:12:56PM +0200, Adrian Bunk wrote:
> On Mon, Oct 08, 2007 at 10:02:55PM +0200, Sam Ravnborg wrote:
> >...
> > The settings are stored in the build directory in a file
> > named "Kbuild.config" (should it be a .dot file?).
> >...
> 
> A .dot file sounds better.
I will make it ".kbuild".
Droppeing the .config bits of the name will hopefully avoid that
people mess with it manually.

> BTW: I'm currently trying without success to understand why the
>      drivers/infiniband/{hw/amso1100,ulp/srp}/Kbuild files are not
>      named "Makefile".
Giacomo explained this already..
But I have never done a global renaming - the
pain/benefit ratio seems too low.

	Sam
