Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYLaSs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYLaSs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYLaSsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:48:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33309 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbYLaSsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:48:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: mmotm 2008-12-30-16-05 uploaded (mmc)
Date: Wed, 31 Dec 2008 19:48:31 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-tst; KDE/4.1.3; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>, Greg KH <greg@kroah.com>
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org> <495AEE05.1080005@oracle.com> <20081231190747.3416280d@mjolnir.drzeus.cx>
In-Reply-To: <20081231190747.3416280d@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812311948.31697.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2008, Pierre Ossman wrote:
> On Tue, 30 Dec 2008 19:59:01 -0800
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2008-12-30-16-05 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://git.zen-sources.org/zen/mmotm.git
> > > 
> > > It contains the following patches against 2.6.28:
> > 
> > 
> > mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:235: error: variable 'ricoh_mmc_pm_opts' has initializer but incomplete type
> > mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:236: error: unknown field 'suspend_noirq' specified in initializer
> > mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:236: warning: excess elements in struct initializer
> > mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:236: warning: (near initialization for 'ricoh_mmc_pm_opts')
> > mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:237: error: unknown field 'resume_noirq' specified in initializer
> > mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:237: warning: excess elements in struct initializer
> > mmotm-2008-1230-1605/drivers/mmc/host/ricoh_mmc.c:237: warning: (near initialization for 'ricoh_mmc_pm_opts')
> > 
> > 
> > struct dev_pm_ops seems not to exist AFAICT.
> > 
> > 
> 
> This is no longer in my tree so it must be some bad ordering in
> Rafael's tree.

That's because the Greg's driver core tree has been dropped temporarily
due to a build error.

Thanks,
Rafael
