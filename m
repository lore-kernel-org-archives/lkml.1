Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbXINLCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbXINLCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXINLCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:02:38 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:23130 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbXINLCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:02:37 -0400
Date: Fri, 14 Sep 2007 13:02:07 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Driver core: remove get_bus()
Message-ID: <20070914130207.0c22c8a6@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070913233850.GB10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
	<20070913233850.GB10856@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 16:38:50 -0700,
Greg KH <greg@kroah.com> wrote:

> get_bus() should not be globally visable as it is not used by anything
> other than drivers/base/bus.c.  This patch removes the visability of it,

Makes sense.

> and renames it to match all of the other *_get() functions in the
> kernel.

What about get_device() and get_driver()? (Not that I want to change
those, but I think the driver core should stick to one naming
convention.)
