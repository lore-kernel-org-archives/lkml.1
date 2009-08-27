Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZH0WXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZH0WXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 18:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZH0WXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 18:23:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbZH0WXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 18:23:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 8] PM: Allow user space to change the power.async_suspend flag of devices
Date: Fri, 28 Aug 2009 00:24:06 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200908262217.19609.rjw@sisk.pl> <200908272120.56021.rjw@sisk.pl> <20090827203634.372EC526EC9@mailhub.coreip.homeip.net>
In-Reply-To: <20090827203634.372EC526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908280024.06082.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 August 2009, Dmitry Torokhov wrote:
> Hi Rafael,
> 
> On Thu, Aug 27, 2009 at 09:20:55PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Add sysfs attribute power/async for every device allowing the user
> > space to access the device's power.async_suspend flag and modify it,
> > if necessary.
> > 
> 
> I don't think we should let users meddle with individual devices;
> one global flag should be enough to work around "broken-at-the-moment"
> issues.

Well, this patch is handy for testing if anyone is interested, so I posted it.

It isn't exactly safe, though, you're right.

Thanks,
Rafael
