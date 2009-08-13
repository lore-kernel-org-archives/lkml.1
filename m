Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbZHMIZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbZHMIZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZHMIZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:25:49 -0400
Received: from smtp2a.orange.fr ([80.12.242.139]:14094 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbZHMIZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:25:48 -0400
X-ME-UUID: 20090813082547818.C7B2A70000AB@mwinf2a11.orange.fr
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
	/dev
From: Xavier Bestel <xavier.bestel@free.fr>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
In-Reply-To: <20090812213348.GY13320@pengutronix.de>
References: <20090805171513.GA10443@kroah.com>
	 <20090812213348.GY13320@pengutronix.de>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 10:25:40 +0200
Message-Id: <1250151940.18980.424.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 23:33 +0200, Robert Schwebel wrote:
> On Wed, Aug 05, 2009 at 10:15:13AM -0700, Greg KH wrote:
> > Here's the devtmpfs patch again.
> 
> As an embedded distro maintainer, I'd really like such an approach. With
> ptxdist, we can today build the complete rootfs for an embedded system
> without root permissions - just if we want to nfs-root boot the boards
> during development, it doesn't work, because you have to create
> /dev/console, /dev/null and /dev/zero and that works only for root.

Have you tried genext2fs ? It lets you create a filesystem image
complete with device nodes as a normal user.

	Xav



