Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXLMVPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXLMVPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760764AbXLMVPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:15:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759264AbXLMVPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:15:46 -0500
Date: Thu, 13 Dec 2007 13:15:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ego@in.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jirislaby@gmail.com
Subject: Re: 2.6.24-rc5-mm1
Message-Id: <20071213131504.41e1ad55.akpm@linux-foundation.org>
In-Reply-To: <20071213122802.GA30427@in.ibm.com>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
	<20071213122802.GA30427@in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 17:58:02 +0530
Gautham R Shenoy <ego@in.ibm.com> wrote:

> Hi Andrew, 
> On Thu, Dec 13, 2007 at 02:40:50AM -0800, Andrew Morton wrote:
> > 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/
> > 
> > - If something goes wrong with a PCI device's probing or initialisation, try
> >   reverting pci-disable-decoding-during-sizing-of-bars.patch.
> > 
> > - git-sched was dropped due to breaking suspend-to-RAM.
> 
> Is it the same suspend-to-RAM problem that Jiri Slaby reported 
> here --> http://lkml.org/lkml/2007/12/7/125

Don't think so (I hit that one too, I think).

There's no mention of get_online_cpus() in git-sched's watchdog(), and my
symptoms are that the machine appears to suspend to RAM OK (but it might
take longer to do this with git-sched applied).  But it never comes back to
life after you hit the power button to resume it.  

I guess I need to bisect it.  That'll be novel.

