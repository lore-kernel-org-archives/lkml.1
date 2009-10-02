Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbZJBNBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbZJBNBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbZJBNBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:01:39 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48189 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732AbZJBNBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:01:38 -0400
Message-ID: <4AC5F975.6060505@s5r6.in-berlin.de>
Date: Fri, 02 Oct 2009 15:00:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.32-rc1-git2: Reported regressions from 2.6.31
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera> <1254469139.3531.19.camel@ht.satnam>
In-Reply-To: <1254469139.3531.19.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> If you add one more entry say "Suspected commit :" then it will be great
> and will solve regressions much faster.

Will?  Might.

> You can request submitter to
> submit 'suspected commit' by git bisect and also specify git bisect
> links like : (for more information about git bisect check
> http://kerneltrap.org/node/11753)

I disagree.  A reporter should only be asked to bisect (using git or
other tools) /if/ a developer determined that bisection may speed up the
debugging process or is the only remaining option to make progress with
a bug.

It would be wrong to steal a reporter's valuable time by asking for
bisection before anybody familiar with the matter even had a first look
at the report.

Remember:
  - Not all bugs can be economically narrowed down by bisection.
  - Bisection requires skills, rigor, and time.
  - Alas there are considerable sections in our kernel history which
    are not bisectable.
-- 
Stefan Richter
-=====-==--= =-=- ---=-
http://arcgraph.de/sr/
