Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbZGTDIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbZGTDIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 23:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZGTDIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 23:08:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:62359 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZGTDIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 23:08:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,231,1246863600"; 
   d="scan'208";a="476265934"
Subject: Re: [PATCH 2/8] introduce the device async action mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20090719221658.GL26511@elf.ucw.cz>
References: <1247643516.26272.77.camel@rzhang-dt>
	 <20090715060006.71c2e2b6@infradead.org>
	 <1247709910.26272.159.camel@rzhang-dt> <200907170312.00006.rjw@sisk.pl>
	 <1247798643.26272.275.camel@rzhang-dt>  <20090719221658.GL26511@elf.ucw.cz>
Content-Type: text/plain; charset=utf-8
Date: Mon, 20 Jul 2009 11:09:36 +0800
Message-Id: <1248059376.26272.311.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 06:16 +0800, Pavel Machek wrote:
> Hi!
> 
> > 
> > that's not enough.
> > ???For examples,
> > ACPI battery and EC are independent devices, but EC must be resumed
> > before battery because battery driver may access some EC address space
> > during resume time.
> 
> Yes, but those dependencies should be pulled from driver tree, not
> adding separate dependencies infrastructure.
> 
Sorry, ﻿the problem I described above is wrong.
We just disable the EC interrupt mode in S3, but it still works.
Battery can access EC address space before EC resumed, in low speed.

﻿
> 
> > > In particular, we have to make sure that parent devices will not be suspended
> > > until all of their children have been suspended and children devices will not
> > > be resumed before the parents.
> > 
this is right.

thanks,
rui

