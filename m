Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbZGSWSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbZGSWSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 18:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbZGSWSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 18:18:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44100 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbZGSWSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 18:18:50 -0400
Date: Mon, 20 Jul 2009 00:16:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/8] introduce the device async action mechanism
Message-ID: <20090719221658.GL26511@elf.ucw.cz>
References: <1247643516.26272.77.camel@rzhang-dt> <20090715060006.71c2e2b6@infradead.org> <1247709910.26272.159.camel@rzhang-dt> <200907170312.00006.rjw@sisk.pl> <1247798643.26272.275.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247798643.26272.275.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  During suspend-resume we know dependencies between
> > devices beforehand, at least in theory, so we can use them.
> > 
> that's why I use multiple async domains. :)
> One domain for a device group.
> 
> > In particular, we have to make sure that parent devices will not be suspended
> > until all of their children have been suspended and children devices will not
> > be resumed before the parents.
> 
> that's not enough.
> ???For examples,
> ACPI battery and EC are independent devices, but EC must be resumed
> before battery because battery driver may access some EC address space
> during resume time.

Yes, but those dependencies should be pulled from driver tree, not
adding separate dependencies infrastructure.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
