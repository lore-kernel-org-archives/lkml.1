Return-Path: <linux-kernel-owner+w=401wt.eu-S1761655AbYJJVeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761655AbYJJVeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764104AbYJJVdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:33:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56097 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764004AbYJJVdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:33:40 -0400
Date: Fri, 10 Oct 2008 23:35:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, jikos@suse.cz,
       kernel list <linux-kernel@vger.kernel.org>, linux-acpi@ucw.cz,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.27-rc8: throttling broken
Message-ID: <20081010213518.GB15285@elf.ucw.cz>
References: <20081009171238.GB1370@ucw.cz> <200810092327.26301.rjw@sisk.pl> <1223601125.3990.4.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223601125.3990.4.camel@yakui_zhao.sh.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-10-10 09:12:05, Zhao Yakui wrote:
> On Thu, 2008-10-09 at 23:27 +0200, Rafael J. Wysocki wrote:
> > On Thursday, 9 of October 2008, Pavel Machek wrote:
> > > Hi!
> > > 
> > > On 2.6.27-rc8 on via/fic subnotebook, throttling seems to be broken. I
> > > can do echo 15 > /proc/acpi/processor/*/throttling, and proc file
> > > reflects new value, but cpu still runs at same speed.
> > > 
> > > It worked on opensuse11/sled10 kernels at least...
> After echo 15 > /proc/acpi/processor/*/throttling, what T-state is
> displayed by cat /proc/acpi/processor/*/throttling?

IIRC that worked correctly. I.e. "*" moved to T15.

> If you do the above test on the 2.6.26.x kernel, what T-state is
> displayed ?

Throttling seems to work there and T15 is correctly marked by "*".

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
