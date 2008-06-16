Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYFPAZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYFPAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 20:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYFPAZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 20:25:17 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58141 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYFPAZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 20:25:16 -0400
Date: Mon, 16 Jun 2008 03:24:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Lior Dotan <liodot@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Brownell <dbrownell@users.sourceforge.net>, a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [Bug 10866] /dev/rtc was missing until I disabled
	CONFIG_RTC_CLASS
Message-ID: <20080616002359.GC1407@cs181133002.pp.htv.fi>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.rFC.L2vSIB@albercik> <20080613193302.GA1716@cs181133002.pp.htv.fi> <a5bf86a80806131255w704745d7mc109c13669ac9c68@mail.gmail.com> <20080613212023.GB1716@cs181133002.pp.htv.fi> <a5bf86a80806150115q2d3ee545y84bae48f84d4fe96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a5bf86a80806150115q2d3ee545y84bae48f84d4fe96@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 11:15:23AM +0300, Lior Dotan wrote:
> On Sat, Jun 14, 2008 at 12:20 AM, Adrian Bunk <bunk@kernel.org> wrote:
> >
> > What is the output of "grep RTC_ .config" on your old .config?
> 
> Here it is:

Thanks.

>...
> CONFIG_RTC_CLASS=y
>...
> # CONFIG_RTC_DRV_CMOS is not set
>...

That means the support for the PC RTC is disabled.

Honestly, I do not think we can handle all possible misconfigurations 
when switching to the new RTC drivers automatically.

> Lior.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

