Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYE1Slt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYE1Slt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 14:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYE1Sll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 14:41:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47281 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbYE1Slk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 14:41:40 -0400
Date: Wed, 28 May 2008 20:42:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Doug Reiland <dreiland@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild changes since 2.6.21??
Message-ID: <20080528184220.GA6055@uranus.ravnborg.org>
References: <6844644e0805280923q6ae8fdd6pcf92f726f420afe4@mail.gmail.com> <6844644e0805281127s47be5b92i71b9684fb41cc596@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6844644e0805281127s47be5b92i71b9684fb41cc596@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 02:27:47PM -0400, Doug Reiland wrote:
> By bad, drivers/power/Makefile is ok.
> I thought I reproduced the issue there.
> 
> On Wed, May 28, 2008 at 12:23 PM, Doug Reiland <dreiland@gmail.com> wrote:
> > There are some makefiles that look at CONFIG_XXXX variables to make
> > decisions. For example, drivers/power/Makefile has the following
> > lines:
> >
> > ifeq ($(CONFIG_SYSFS),y)
> > power_supply-objs += power_supply_sysfs.o
> > endif
> >
> >
> > If I run make clean or make mrproper, it doesn't see CONFIG_SYSFS set
> > anymore so it doesn't cleanup power_supply_sysfs.o.
> >
> > This is for 2.6.25, but I think this use to work for 2.6.21. I am
> > using drivers/power/Makefile as an example, but I am seeing the same
> > thing for my driver's Makefile.

We use find to delete all .o files. So the content of your Kbuild file
should not matter here.
Can you describe the setup where you see the issue?

	Sam
