Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbXIZBqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbXIZBqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbXIZBqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:46:12 -0400
Received: from tomts4.bellnexxia.net ([209.226.175.10]:46298 "EHLO
	tomts4-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbXIZBqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:46:10 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2007 21:46:09 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAF1V+UZFn+Sr/2dsb2JhbACmXw
Date: Tue, 25 Sep 2007 21:39:31 -0400
From: Mike Houston <mikeserv@bmts.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
Message-Id: <20070925213931.7c0c43bc.mikeserv@bmts.com>
In-Reply-To: <20070925150500.GA2632@localhost.localdomain>
References: <20070925065109.GA3080@localhost.localdomain>
	<20070925092755.GA4553@localhost.localdomain>
	<20070925095855.GA4982@localhost.localdomain>
	<200709251345.11370.rjw@sisk.pl>
	<20070925120202.GA5641@localhost.localdomain>
	<20070925150500.GA2632@localhost.localdomain>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 17:05:00 +0200
Damien Wyart <damien.wyart@free.fr> wrote:

> > Will test this evening the patch you pointed in your next message.
> 
> Ok, with both patches (including the very latest one from Alexey ---
> tried the "stylistically correct" one), machine halts fine again.
> Thanks to all for having looked at this!

Same here, applying the two patches in this thread fixed the problem
for me, on my Intel 965P based system. It now does the acpi power off
correctly once again, and I have noticed no other problems with
2.6.23-rc8.

"move acpi_sleep_prepare outside of CONFIG_SUSPEND" and the last
"ACPI: suspend: fix ACPI_SLEEP states"

Thanks Alexey and Rafael.

Mike Houston
