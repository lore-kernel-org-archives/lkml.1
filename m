Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbYCTUaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbYCTUaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbYCTUXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:23:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2621 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757709AbYCTUXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:23:13 -0400
Date: Thu, 20 Mar 2008 21:22:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rae l <crquan@gmail.com>
Cc: David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@linux.intel.com>, Nick Piggin <npiggin@suse.de>,
       Len Brown <len.brown@intel.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: many items in Documentation/feature-removal-schedule.txt have expired, please update
Message-ID: <20080320202215.GD4397@ucw.cz>
References: <91b13c310803200622k6a302851nc97774615f2ef3ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310803200622k6a302851nc97774615f2ef3ee@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-20 21:22:29, rae l wrote:
> I noticed that many feature removal schedule marked in this file have
> expired, so please update information:
> 1. if the feature has been removed, please remove it from this file;
> 2. if it does not, please update the schedule date;


> What:	dev->power.power_state
> When:	July 2007
> Why:	Broken design for runtime control over driver power states, confusing
> 	driver-internal runtime power management with:  mechanisms to support
> 	system-wide sleep state transitions; event codes that distinguish
> 	different phases of swsusp "sleep" transitions; and userspace policy
> 	inputs.  This framework was never widely used, and most attempts to
> 	use it were broken.  Drivers should instead be exposing domain-specific
> 	interfaces either to kernel or to userspace.
> Who:	Pavel Machek <pavel@suse.cz>

Feel free to help killing remaining power_state users, then it can
disappear.

I won't update the date: it is in past to remind people that it should
have been killed already.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
