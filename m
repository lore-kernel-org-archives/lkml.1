Return-Path: <linux-kernel-owner+w=401wt.eu-S940266AbXGSQ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940266AbXGSQ4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940109AbXGSQzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:55:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34958 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940095AbXGSQzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:55:50 -0400
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
From: Arjan van de Ven <arjan@infradead.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Christian Ehrhardt <lk@c--e.de>, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <20070719122424.GA5186@vino.hallyn.com>
References: <Line.LNX.4.64.0707141233490.26711@d.namei>
	 <20070718183503.541026f8.akpm@linux-foundation.org>
	 <20070719073948.GI18840@lisa.in-ulm.de>
	 <20070719122424.GA5186@vino.hallyn.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 19 Jul 2007 09:54:30 -0700
Message-Id: <1184864070.2694.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Right, the ability to boot with security.capability=disabpled (or
> whatever) and then load a custom module without having to use a whole
> new kernel is something I'm sure end-users want.
> 
> Especially since compiling a kernel which works with, say, a default
> fedora install, with lvm etc, is not imo for a novice (where novice
> != security novice).

the next step after this patch is to have an option to get rid of all
the function pointer chasing (which is expensive) for the case where you
know you only want one security module (which you then can turn on or
off)... that advantage is a performance gain for a lot of people.... but
if the person configuring the kernel selects this, it does mean there's
no way to load modules. I don't know what Fedora will do, but they might
select such an option. That's CHOICE... they chose a performance
improvement over enabling external kernel modules that they don't ship
anyway...

but is it really worth blocking such clear improvements in performance?

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

