Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZIJS7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZIJS7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZIJS7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:59:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45007 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbZIJS7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:59:05 -0400
Date: Thu, 10 Sep 2009 20:59:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/9] PM: Add a switch for disabling/enabling
	asynchronous suspend/resume
Message-ID: <20090910185901.GB23356@elf.ucw.cz>
References: <200909100127.11252.rjw@sisk.pl> <200909100138.25839.rjw@sisk.pl> <20090910102653.GA30778@atrey.karlin.mff.cuni.cz> <200909102056.39903.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909102056.39903.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-09-10 20:56:39, Rafael J. Wysocki wrote:
> On Thursday 10 September 2009, Pavel Machek wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Add sysfs attribute kernel/power/pm_async allowing the user space to
> > > disable and enable async suspend/resume of devices.
> > 
> > for bisect reasons, should this go before 5?
> 
> It is set to "enabled" by default, so it shouldn't change bisection results.

Well, 5 enables it, 6 makes it configurable. So if you need async
disabled for a bisect, hitting commit between 5 and 6 will enable it
for you...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
