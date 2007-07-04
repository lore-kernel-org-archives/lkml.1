Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbXGDOX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbXGDOX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759845AbXGDOXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:23:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758184AbXGDOXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:23:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 16:30:29 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707041310.11336.rjw@sisk.pl> <18059.33636.66185.902453@cargo.ozlabs.ibm.com>
In-Reply-To: <18059.33636.66185.902453@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041630.30048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 4 July 2007 13:24, Paul Mackerras wrote:
> Rafael J. Wysocki writes:
> 
> > BTW, does your platform's suspend work on SMP systems?
> 
> Yes; currently we require userspace to offline all cpus other than the
> boot cpu before initiating the suspend.

This is incompatible with the code in kernel/power/main.c, since we only
disable the nonboot CPUs after devices have been suspended.  Do you think that
your framework can be modified to work without disabling the nonboot CPUs
by the user space?

> The main difficulty is actually that SMP powermacs that can suspend
> tend to have video cards that get powered off in suspend.  We know how
> to re-initialize one (the Radeon RV100 QW) but not others.  That's an
> orthogonal issue to the issues we have been discussing, though.

Sure.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
