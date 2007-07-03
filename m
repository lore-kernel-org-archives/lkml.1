Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbXGCNAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbXGCNAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbXGCNAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:00:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44564 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707AbXGCNAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:00:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 15:07:52 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
References: <20070703042916.GA17240@srcf.ucam.org> <1183441748.10386.75.camel@localhost.localdomain>
In-Reply-To: <1183441748.10386.75.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031507.52875.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 07:49, Benjamin Herrenschmidt wrote:
> On Tue, 2007-07-03 at 05:29 +0100, Matthew Garrett wrote:
> > Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> > a screaming nightmare - either the suspend fails because syslog (for 
> > instance) can't be frozen, or the machine deadlocks for some other 
> > reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> > could do what we do for suspend to RAM on other platforms (PPC and APM) 
> > and just not use the freezer.
> > 
> > Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> (And with much pleasure :-)

Clashes with some code already in -mm.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
