Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbXIFWeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbXIFWeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 18:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbXIFWdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 18:33:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47502 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbXIFWdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 18:33:50 -0400
Date: Fri, 7 Sep 2007 00:33:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] build system: section garbage collection for vmlinux
Message-ID: <20070906223358.GA10101@uranus.ravnborg.org>
References: <200709051443.21522.vda.linux@googlemail.com> <200709051940.15653.vda.linux@googlemail.com> <20070905204628.GE30812@uranus.ravnborg.org> <200709061155.52661.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709061155.52661.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 11:55:52AM +0100, Denys Vlasenko wrote:
> 
> > Doing a normal kernel build will link vmlinux three or four times.
> > If we introduce --gc-sections we should add a preparational link of
> > vmlinux where we use --gc-sections and skip it for the rest of the links
> > assuming that --gc-sections takes some time for ld to do.
> 
> Yes, this will speed up things a bit.
> 
> However, for me build time is totally dominated by CC stages, not LD.

A typical developer workflow is editing a single file
and then build the kernel.
Here CC has much less impact than LD - and this is the case we shall optimize for.

	Sam
