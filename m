Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbXGCMt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbXGCMt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 08:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbXGCMtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 08:49:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44470 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbXGCMtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:49:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 14:56:35 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20070703042916.GA17240@srcf.ucam.org>
In-Reply-To: <20070703042916.GA17240@srcf.ucam.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707031456.36027.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 06:29, Matthew Garrett wrote:
> Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> a screaming nightmare - either the suspend fails because syslog (for 
> instance) can't be frozen, or the machine deadlocks for some other 
> reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> could do what we do for suspend to RAM on other platforms (PPC and APM) 
> and just not use the freezer.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

Could you please rediff against the current -mm tree?

There are some patches in there that this will clash with.

I still think that this is a mistake, BTW.  Please see the Alan's post at

https://lists.linux-foundation.org/pipermail/linux-pm/2007-June/012847.html

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
