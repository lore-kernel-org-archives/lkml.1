Return-Path: <linux-kernel-owner+w=401wt.eu-S1422732AbXBOXux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422732AbXBOXux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422729AbXBOXux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:50:53 -0500
Received: from gw.goop.org ([64.81.55.164]:58442 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422728AbXBOXuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:50:51 -0500
Message-ID: <45D4F1C1.7060103@goop.org>
Date: Thu, 15 Feb 2007 15:50:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Pavel Machek <pavel@ucw.cz>, Alan <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
References: <200702060353.l163rUmj000771@zach-dev.vmware.com> <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com> <20070207123552.GD4481@ucw.cz> <1170880572.11736.4.camel@localhost.localdomain> <20070214125216.2befda78@localhost.localdomain> <45D36B49.5090109@vmware.com> <20070215101713.GK26240@elf.ucw.cz> <45D4F003.4030502@vmware.com>
In-Reply-To: <45D4F003.4030502@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> So Rusty, Chris, Jeremy, any objections to killing udelay() and
> friends in paravirt-ops?  It would simplify things a bit.  The only
> thing we lose is a slightly faster boot time in the 100% emulated
> device case.  I'm ok with losing that.  Even the PIT fast paths don't
> use udelay, so I don't think we care for runtime performance at all. 

Fine with me.  That always seemed a bit warty to me.

    J
