Return-Path: <linux-kernel-owner+w=401wt.eu-S1030519AbXCVLpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519AbXCVLpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 07:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030567AbXCVLpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 07:45:12 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51002 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030519AbXCVLpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 07:45:11 -0400
Date: Thu, 22 Mar 2007 12:45:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>,
       virtualization <virtualization@lists.osdl.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lguest: clean rest of linkage warnings (bar one)
Message-ID: <20070322114549.GC29453@uranus.ravnborg.org>
References: <1174532243.2713.95.camel@localhost.localdomain> <1174558182.2713.151.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174558182.2713.151.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 09:09:42PM +1100, Rusty Russell wrote:
> My previous warning fix broke lguest if your text size wasn't correct
> to make the __start_paravirtprobe aligned correctly.  Put the separate
> paravirtprobe section back, but inside the init section so it gets
> discarded.
> 
> It also fixes the remaining warnings, except one.  The code in
> modpost.c which needs to be taught that it's legal to link from
> .paravirtprobe to .init.text is horrible, and I'm pretty sure I'd just
> make it worse.

If you drop me a sample of the exact warning I will add this one too.
Current kbuild.git contains a lot of fixes in this area so I refer to
do so on top of that tree.

	Sam
