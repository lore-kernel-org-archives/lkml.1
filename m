Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZIJSzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZIJSzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZIJSzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:55:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40156 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbZIJSzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:55:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 6/9] PM: Add a switch for disabling/enabling asynchronous suspend/resume
Date: Thu, 10 Sep 2009 20:56:39 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <200909100127.11252.rjw@sisk.pl> <200909100138.25839.rjw@sisk.pl> <20090910102653.GA30778@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20090910102653.GA30778@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909102056.39903.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 September 2009, Pavel Machek wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Add sysfs attribute kernel/power/pm_async allowing the user space to
> > disable and enable async suspend/resume of devices.
> 
> for bisect reasons, should this go before 5?

It is set to "enabled" by default, so it shouldn't change bisection results.

Thanks,
Rafael
