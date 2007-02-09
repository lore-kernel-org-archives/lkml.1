Return-Path: <linux-kernel-owner+w=401wt.eu-S1946424AbXBIMcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946424AbXBIMcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946427AbXBIMcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:32:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41793 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946428AbXBIMcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:32:17 -0500
Subject: Re: -mm merge plans for 2.6.21
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederik Deweerdt <deweerdt@free.fr>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <20070209033936.41be141b.akpm@linux-foundation.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	 <Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr>
	 <20070209105737.GF5785@slug>
	 <1171020273.8675.150.camel@laptopd505.fenrus.org>
	 <20070209033936.41be141b.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 09 Feb 2007 13:32:12 +0100
Message-Id: <1171024332.8675.155.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> As long as nobody takes the address of them (which wouldn't compile today
> anyway) then the compiler should be able to not allocate store for these. 
> That they're const might help too.

are you really sure?
> 
> > why not just bite the bullet?
> > removing version.h also broke the same all external modules, and they
> > got fixed in days.. no big deal. kernel api change all the time, this
> > one has been around in "double mode" quite some time...
> 
> Pretty much every driver in the world will want these symbols.  I expect
> we'll help some people by doing this, and the cost to us is very small.  


well the same people had to change for the request_irq prototype change
etc etc.

I suppose they'll all get fixed if some distro does this cleanup
anyway... otherwise no amount of deprecation will get things changed;
unless the compile actually breaks nobody will pay attention.

Also quite a few external drivers that are aiming for mainline inclusion
should already be using the new settings for a while anyway...


Another option is to back out the change again totally; having 2
constants for the same thing is just a bad idea, and old users will keep
sneaking in.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

