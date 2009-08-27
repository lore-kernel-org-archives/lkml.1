Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZH0U6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZH0U6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 16:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZH0U6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 16:58:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41278 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZH0U6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 16:58:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 6/6] PM: Allow serio input devices to suspend/resume asynchronously
Date: Thu, 27 Aug 2009 22:58:35 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200908262217.19609.rjw@sisk.pl> <200908262224.19110.rjw@sisk.pl> <20090827204106.1132B526EC9@mailhub.coreip.homeip.net>
In-Reply-To: <20090827204106.1132B526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908272258.35861.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 August 2009, Dmitry Torokhov wrote:
> On Wed, Aug 26, 2009 at 10:24:19PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Set async_suspend for all serio input devices, so that they can be
> > suspended and resumed asynchronously with other devices they don't
> > depend on in a known way (i.e. devices which are not their parents
> > or children and to which they are not connected via struct pm_link
> > objects).
> > 
> 
> As I mentioned not yet, please - i8042 may be unhappy if you pound
> all its ports at once. I should have a solution for it though.

OK, I'll drop this patch.

Thanks,
Rafael
