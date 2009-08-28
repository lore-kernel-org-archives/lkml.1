Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbZH1TlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbZH1TlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZH1TlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:41:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44741 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbZH1TlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:41:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 7 updated] PM: Add a switch for disabling/enabling asynchronous suspend/resume
Date: Fri, 28 Aug 2009 21:42:05 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200908262217.19609.rjw@sisk.pl> <200908280022.40522.rjw@sisk.pl> <20090828055520.E561A526EC9@mailhub.coreip.homeip.net>
In-Reply-To: <20090828055520.E561A526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908282142.05812.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 August 2009, Dmitry Torokhov wrote:
> On Fri, Aug 28, 2009 at 12:22:40AM +0200, Rafael J. Wysocki wrote:
> > +/* kernel/power/main.c */
> > +extern int pm_async_enabled;
> >  
> 
> Sorry, forgot about this in the first mail - why don't we make it a
> bool?

I didn't do that because of the

sprintf(buf, "%d\n", pm_async_enabled)

in pm_async_show(), where it clearly is treated as an int.

Thanks,
Rafael
