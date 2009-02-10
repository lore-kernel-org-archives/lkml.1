Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZBJAL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZBJAL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 19:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZBJALt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 19:11:49 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58282 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbZBJALs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 19:11:48 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH] sh: maple: add support for Visual Memory Card devices, and make consequential changes to maple input drivers - 2/3 - v5
Date: Mon, 9 Feb 2009 19:11:43 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.28; KDE/4.2.0; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>
References: <1234122069.6736.8.camel@localhost.localdomain> <200902091433.57126.vapier@gentoo.org> <1234215716.6756.18.camel@localhost.localdomain>
In-Reply-To: <1234215716.6756.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902091911.46383.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009 16:41:56 Adrian McMenamin wrote:
> But the basic point here is that changing the bus code is necessary to
> get the VMU driver (or *any* VMU driver) to work, but changing the bus
> driver also breaks the two existing drivers in mainline that use the
> bus. The breakage in terms of lines to be fixed is small, but it still
> needs to be done 'all at once'.

the bus change and the resulting fallout in those drivers should be 1 
changeset.  if you want to do more work than just transitioning those drivers, 
that should be additional patches that depend on that bus changeset.  that way 
bisection will not break as Paul highlighted.
-mike
