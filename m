Return-Path: <linux-kernel-owner+w=401wt.eu-S933276AbZHDSo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbZHDSo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933255AbZHDSo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:44:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48691 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976AbZHDSo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:44:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
Date: Tue, 4 Aug 2009 20:44:40 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "dtor@mail.ru" <dtor@mail.ru>
References: <Pine.LNX.4.44L0.0908041330040.3102-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908041330040.3102-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908042044.41170.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009, Alan Stern wrote:
> On Tue, 4 Aug 2009, Rafael J. Wysocki wrote:
> 
> > Not only that.  I'd like to simplify the design, because IMO using one async
> > domain would be much more straightforward than using multiple ones.
> 
> > If I understand the async framework correctly, the domains are only used for
> > synchronization, ie. if you want to wait for a group of async operations to
> > complete, you can put them all into one domain and then call
> > async_synchronize_full_domain() to wait for them all together.
> > 
> > You don't need multiple domains to run multiple things in parallel.
> 
> There's a basic confusion going on here.
> 
> Rui is using "async domain" to mean a collection of devices which 
> will be suspended or resumed serially.  Different domains run in 
> parallel.
> 
> Rafael is using "async domain" to mean a collection of devices which 
> will be suspended or resumed in parallel.  Different domains run 
> serially.
> 
> Once that is cleared up, you should be able to communicate a little 
> better...  :-)

Well, I tried to follow the naming convention of kernel/async.c.

Best,
Rafael
