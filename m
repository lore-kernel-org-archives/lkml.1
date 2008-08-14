Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbYHNQdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbYHNQdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYHNQdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:33:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55398 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYHNQdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:33:31 -0400
Date: Thu, 14 Aug 2008 18:34:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Warning in during hotplug on 2.6.27-rc2-git5
Message-ID: <20080814163450.GA13814@one.firstfloor.org>
References: <200808121700.20369.mark.langsdorf@amd.com> <200808141753.58547.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808141753.58547.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 05:53:57PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, 13 of August 2008, Mark Langsdorf wrote:
> > I'm seeing the following error message when I hotunplug and replug
> > a cpu in 2.6.27-rc2-git5.  The system becomes unstable almost
> > immediately afterwards.
> 
> Hm, it seems that MCE is involved somehow.  Andi, can you have a look at this,
> please?

FWIW the mce code here actually hasn't changed for a long time.


> > ------------[ cut here ]------------
> > WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x33/0x39()
> > sysfs: duplicate filename 'machinecheck4' can not be created

The only way I could see that happening if CPU_DEAD/CPU_ONLINE
is not properly balanced.

-Andi
