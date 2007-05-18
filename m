Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbXERFkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbXERFkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 01:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXERFjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 01:39:52 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:65042 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761488AbXERFju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 01:39:50 -0400
Date: Fri, 18 May 2007 07:39:46 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "NeilBrown" <neilb@suse.de>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "linux-s390" <linux-s390@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1 - s390 vs. md
Message-ID: <20070518073946.716132f4@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201DEA0F1@azsmsx413.amr.corp.intel.com>
References: <0C7297FA1D2D244A9C7F6959C0BF1E5201DEA0F1@azsmsx413.amr.corp.intel.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 23:36:56 -0700,
"Williams, Dan J" <dan.j.williams@intel.com> wrote:

> async_tx: add the Kconfig infrastructure for async_tx
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> async_tx is similar to crypto in that there is an api component and a
> drivers component.
> 
> * Add 'source "async_tx/Kconfig"' to the per architecture Kconfig files,
>   for each architecture that sources drivers/md/Kconfig (which appears
> to be
>   all of them).
> * Add 'select' statements for the subsystems that use async_tx
> (md-raid4,5)

Finer granularity is certainly better here, but I'm not quite sure if
this solves our s390 problem (we don't have dma support). All those
backends should also have a non-dma version...
