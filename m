Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0BOHeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:34:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42810 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab0BOHeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:34:09 -0500
Date: Mon, 15 Feb 2010 08:34:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: register long sp asm("r1") incorrect
Message-ID: <20100215073405.GB20456@atrey.karlin.mff.cuni.cz>
References: <20100209152444.GA30176@atrey.karlin.mff.cuni.cz> <1265866273.16346.34.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265866273.16346.34.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2010-02-09 at 16:24 +0100, Pavel Machek wrote:
> > ...according to gcc docs, sp should be global, or placement in
> > register is not guaranteed (except at asm boundaries, but there are
> > none).
> 
> Sorry I'm not sure I grok what you mean.

Well, according to gcc doscs and my experience, local "register int
__asm()" variables only work by accident (or not at all).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
