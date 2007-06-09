Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbXFIUAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbXFIUAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759123AbXFIT7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:59:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758904AbXFIT7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:59:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches v2
Date: Sat, 9 Jun 2007 22:05:40 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@redhat.com>, Jean-Luc Coulon <jean.luc.coulon@gmail.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, Ingo Molnar <mingo@elte.hu>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Simon <sg02r@ecs.soton.ac.uk>, linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Paulo Pereira <pfmp.404@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>
References: <466AE54A.3040902@googlemail.com> <466AE619.2000706@googlemail.com>
In-Reply-To: <466AE619.2000706@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706092205.43420.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 9 June 2007 19:40, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-rc4
> with patches available.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> 
> 
> SATA/PATA
> 
> Subject    : disk on promise pdc20378 disabled at boot
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8587
> Submitter  : Jean-Luc Coulon <jean.luc.coulon@gmail.com>
> Handled-By : Tejun Heo <htejun@gmail.com>
> Caused-By  : Tejun Heo <htejun@gmail.com>
>              commit 464cf177df7727efcc5506322fc5d0c8b896f545
> Patch      : http://lkml.org/lkml/2007/6/6/112
> Status     : patch available
> 
> 
> 
> SELinux
> 
> Subject    : very high non-preempt latency in context_struct_compute_av()
> References : http://lkml.org/lkml/2007/6/4/78
> Submitter  : Ingo Molnar <mingo@elte.hu>
> Handled-By : Stephen Smalley <sds@tycho.nsa.gov>
>              James Morris <jmorris@namei.org>
> Patch      : http://lkml.org/lkml/2007/6/7/334
> Status     : patch available
> 
> 
> 
> Suspend
> 
> Subject    : panic on s3 resume with uhci_hcd module
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8565
> Submitter  : Simon <sg02r@ecs.soton.ac.uk>
> Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
> Patch      : http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/21-firewire-implement-suspend-resume-hooks.patch
> Status     : patch available

The patch is already in 2.6.22-rc4, AFAICS.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
