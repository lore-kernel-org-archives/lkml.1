Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXDBKrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXDBKrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933063AbXDBKrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:47:39 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:55510 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045AbXDBKri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:47:38 -0400
Date: Mon, 2 Apr 2007 12:49:44 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <gregkh@suse.de>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andres Salomon <dilinger@debian.org>
Subject: Re: [patch 2.6.21-rc5-git 1/2] fix hotplug for legacy platform
 drivers
Message-ID: <20070402124944.0ad74092@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200703311455.38490.david-b@pacbell.net>
References: <200703311455.38490.david-b@pacbell.net>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 14:55:38 -0700,
David Brownell <david-b@pacbell.net> wrote:

> This fix uses the newish per-device flag controlling issuance of "add" events.
> (A previous version of this patch used a per-device "driver can hotplug" flag,
> which only scrubbed $MODALIAS from the environment rather than suppressing the
> entire hotplug event.)  It also shrinks that flag to one bit, saving a word in
> "struct device".

Would this still work on top of
driver-core-suppress-uevents-via-filter.patch (in -mm), which
suppresses all uevents (not just the add event)? I'd think yes, but I'm
not that familiar with platform devices :)
