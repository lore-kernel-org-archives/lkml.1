Return-Path: <linux-kernel-owner+w=401wt.eu-S1760433AbXEKBMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760433AbXEKBMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbXEKBMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:12:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbXEKBMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:12:22 -0400
Date: Thu, 10 May 2007 18:10:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>,
       pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alexey Dobriyan <adobriyan@sw.ru>,
       netdev@vger.kernel.org, Auke Kok <auke-jan.h.kok@intel.com>,
       Doug Chapman <doug.chapman@hp.com>, Jeb Cramer <cramerj@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       e1000-devel@lists.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.21-gitX: known regressions
Message-Id: <20070510181044.d0f24e51.akpm@linux-foundation.org>
In-Reply-To: <46430A3D.4030004@googlemail.com>
References: <46430A3D.4030004@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 14:04:13 +0200
Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Hi all,
> 
> Here is a list of some known regressions in 2.6.21-gitX.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
> 
> 
> 
> Unclassified:
> 
> Subject    : 2.6.21-git10/11: files getting truncated on xfs (after suspend/resume?)
> References : http://lkml.org/lkml/2007/5/9/410
> Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
> Handled-By : David Chinner <dgc@sgi.com>
> Status     : problem is being debugged
> 
> Subject    : Current -git kernel kills X
> References : http://lkml.org/lkml/2007/5/8/667
> Submitter  : Jeff Garzik <jeff@garzik.org>
> Status     : Unknown
> 
> 
> 
> Block devices:
> 
> Subject    : BUG in loop.ko
> References : http://lkml.org/lkml/2007/5/9/510
> Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
> Status     : Unknown
> 
> 
> 
> Networking:
> 
> Subject    : panic with e1000 driver on HP Integrity servers
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8455
> Submitter  : Doug Chapman <doug.chapman@hp.com>
> Caused-By  : Auke Kok <auke-jan.h.kok@intel.com>
>              commit e0aac5a289b1dacbc94bd9ae8c449bcdf9ab508c
> Status     : Unknown
> 
> 
> 
> Timers/NOHZ:
> 
> Subject    : 2.6.21-git4 BUG: soft lockup detected on CPU#1! 
> References : http://lkml.org/lkml/2007/5/2/511
> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> Status     : problem is being debugged
> 

Please also consider:

Subject: libata reset-seq merge broke sata_sil on sh
Subject: [Bugme-new] [Bug 8462] New: applications under wine freezes

But we have many many more regressions which are in 2.6.21.x, only nobody's
tracking those.  Nobody seems to be fixing them either.  Probably
everyone's busy on the 2.6.14 regressions.

