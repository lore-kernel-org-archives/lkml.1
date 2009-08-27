Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbZH0TXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbZH0TXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 15:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZH0TXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 15:23:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZH0TXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 15:23:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 0/6] PM: Asynchronous suspend and resume of devices
Date: Thu, 27 Aug 2009 21:17:52 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200908262217.19609.rjw@sisk.pl> <200908270025.34821.rjw@sisk.pl>
In-Reply-To: <200908270025.34821.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908272117.52931.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 August 2009, Rafael J. Wysocki wrote:
> On Wednesday 26 August 2009, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > The following patches introduce a mechanism allowing us to execute device
> > drivers' suspend and resume callbacks asynchronously during system sleep
> > transitions, such as suspend to RAM.
> > 
> > The idea is explained in the changelogs of the first two patches.
> > 
> > Comments welcome.
> 
> Forgot to say, the patchset is on top of the linux-next branch of suspend-2.6.

I have two more patches in this series.  The first one introduces a sysfs
switch allowing the user space to block the async suspend/resume.  The second
one gives the user space access to the power.async_suspend flag of devices
through sysfs.

The patches will follow in the next messages.

Thanks,
Rafael

