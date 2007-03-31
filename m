Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbXCaQo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbXCaQo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXCaQo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:44:28 -0400
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:42700 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398AbXCaQo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:44:27 -0400
Date: Sat, 31 Mar 2007 10:42:21 -0600
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [1/4] 2.6.21-rc5: known regressions (v2)
Message-ID: <20070331164221.GA14671@ellpspace.math.ualberta.ca>
Reply-To: michal@harddata.com
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070330213209.GM14134@stusta.de> <20070331002310.GA3213@ellpspace.math.ualberta.ca> <20070331150123.GU14134@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331150123.GU14134@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 05:01:23PM +0200, Adrian Bunk wrote:
> On Fri, Mar 30, 2007 at 06:23:10PM -0600, Michal Jaegermann wrote:
> > On Fri, Mar 30, 2007 at 11:32:09PM +0200, Adrian Bunk wrote:
> > > 
> > > Subject    : kernels fail to boot with drives on ATIIXP controller
> > >              (ACPI/IRQ related)
> > > References : https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229621
> > >              http://lkml.org/lkml/2007/3/4/257
> > > Submitter  : Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
> > > Status     : unknown
> > 
> > I have now even better one with pata_via.  A kernel, which for
> > all practical purposes is 2.6.21-rc5, not only refuses to boot
> > (and I cannot find some option combination which would allow me to
> > do so anyway) but simply refuses to read _any_ data from a media.
> > This included a partitioning information.
> > 
> > Earlier kernel on the same hardware boots without raising any fuss.
> > 
> > Details are collected as
> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=234650
> 
> If I understand this correctly, a plain 2.6.20 kernel is already broken?

You mean that a quoted report talks about 2.6.20-1.3025.fc7 kernel?
These are vagaries of kernel version numbering in Fedora.
Changelogs are not that clear but it appears that
2.6.19-1.2911.6.4.fc6 will be actually closer to 2.6.20.
That kernel from a bug report is really, for all intents and purposes,
2.6.21-rc5 (if I am not misreading something).

I am afraid that I do not have at this moment an easy to way to check
"plain" 2.6.20 on the hardware in question.  It appears that the
essential difference is that a working kernel is using and old IDE
driver, and sees the drive - in this case - as /dev/hdc, while the
current one tries to go through libata and chockes uncontrollably.

   Michal
