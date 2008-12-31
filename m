Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYLaSH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYLaSH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbYLaSHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:07:51 -0500
Received: from server.drzeus.cx ([85.8.24.28]:53084 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755422AbYLaSHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:07:50 -0500
Date: Wed, 31 Dec 2008 19:07:47 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: mmotm 2008-12-30-16-05 uploaded (mmc)
Message-ID: <20081231190747.3416280d@mjolnir.drzeus.cx>
In-Reply-To: <495AEE05.1080005@oracle.com>
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
	<495AEE05.1080005@oracle.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008 19:59:01 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2008-12-30-16-05 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.28:
> 
> 
> mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:235: error: variable 'ricoh_mmc_pm_opts' has initializer but incomplete type
> mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:236: error: unknown field 'suspend_noirq' specified in initializer
> mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:236: warning: excess elements in struct initializer
> mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:236: warning: (near initialization for 'ricoh_mmc_pm_opts')
> mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:237: error: unknown field 'resume_noirq' specified in initializer
> mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:237: warning: excess elements in struct initializer
> mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:237: warning: (near initialization for 'ricoh_mmc_pm_opts')
> 
> 
> struct dev_pm_ops seems not to exist AFAICT.
> 
> 

This is no longer in my tree so it must be some bad ordering in
Rafael's tree.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
