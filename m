Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbXGDK0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbXGDK0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbXGDKZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:25:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48469 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955AbXGDKZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:25:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 12:33:17 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707032332.49694.rjw@sisk.pl> <18059.5165.861038.392332@cargo.ozlabs.ibm.com>
In-Reply-To: <18059.5165.861038.392332@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041233.18199.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 4 July 2007 05:29, Paul Mackerras wrote:
> Rafael J. Wysocki writes:
> 
> > Still, do you really think that we're ready to drop it _right_ _now_ (I'm
> > referring to suspend only) and if so than on what basis (except that you
> > don't like it, which falls short of being a techical argument)?
> 
> The basis is that it (the freezer) causes more deadlocks and other
> problems than it avoids, so it's a net win to remove it.

So, I gather, you're volunteering to handle suspend-related bug reports
from the point in which we drop the freezer from the suspend code path?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
