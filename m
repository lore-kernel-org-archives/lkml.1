Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0CNUFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 16:05:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33806 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab0CNUFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 16:05:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, Mark Gross <mgross@linux.intel.com>
Subject: Re: [PATCH] PM_QOS updates for 2.6.34-rc1
Date: Sun, 14 Mar 2010 21:08:07 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dwalker@codeaurora.org, tiwai@suse.de, bruce.w.allan@intel.com,
       aili@codeaurora.org, khilman@deeprootsystems.com
References: <20100314003425.GA17812@mgross-acer> <20100314062637.GA12064@elf.ucw.cz>
In-Reply-To: <20100314062637.GA12064@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003142108.07164.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 March 2010, Pavel Machek wrote:
> On Sat 2010-03-13 16:34:25, 640E9920 wrote:
> > The following patch series implements to following:
> > 1) pm_qos now uses a handle based implementation.  No more string
> > compares while walking lists.
> > 2) renames the exports to using more accurate names.
> > 3) updates kernel clients of pm_qos per this change
> > 4) added ascii interface to pmqos recognizing strings formatted in 10
> > charactor format "0x12345678"
> > 5) added new pm_qos class, "system_bus_throughput"
> > 
> > I would like to see this series make it into 2.6.34 if its not too late. 
> 
> I believe it is... -rc1 is past us.

It definitely is.

> Also... the way the patches are structured... that will break bisect, no?

Not only that.  Some changelogs would be heartily welcome.  In short, what
change the particular patch is going to make and why it's useful.

Rafael
