Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbZDQVPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbZDQVPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZDQVPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:15:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42919 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbZDQVPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:15:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #13099] net, sky2: BUG: unable to handle kernel NULL pointer dereference, pci_vpd_truncate()
Date: Fri, 17 Apr 2009 23:14:49 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.Q2.cw85JB@chimera> <20090417004517.GB1988@elte.hu>
In-Reply-To: <20090417004517.GB1988@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904172314.50380.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13099
> > Subject		: net, sky2: BUG: unable to handle kernel NULL pointer dereference, pci_vpd_truncate()
> > Submitter	: Ingo Molnar <mingo@elte.hu>
> > Date		: 2009-04-06 9:03 (11 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123900867611321&w=4
> > Handled-By	: Stephen Hemminger <shemminger@vyatta.com>
> 
> I think this can be closed as the fix has been merged upstream 
> already (via the PCI tree):
> 
>  commit d407e32efe060afa2b9a797a91376ebc65b4ce11
>  Author: Anton Vorontsov <avorontsov@ru.mvista.com>
>  Date:   Wed Apr 1 02:23:41 2009 +0400
> 
>     PCI: Fix oops in pci_vpd_truncate

Thanks, closed.

Rafael
