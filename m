Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbYFOQUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbYFOQUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 12:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758308AbYFOQUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 12:20:06 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:65151 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758255AbYFOQUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 12:20:05 -0400
X-Trace: 28680085/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.82.193
X-SBRS: None
X-RemoteIP: 81.1.82.193
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAA/eVEhRAVLB/2dsb2JhbACBW6ov
X-IronPort-AV: E=Sophos;i="4.27,648,1204502400"; 
   d="scan'208";a="28680085"
Subject: Re: [PATCH] input: add support for SEGA Dreamcast controller as
	joystick
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, linux-sh <linux-sh@vger.kernel.org>,
       linux-input@vger.kernel.org
In-Reply-To: <20080519114515.ZZRA012@mailhub.coreip.homeip.net>
References: <1211138322.6354.5.camel@localhost.localdomain>
	 <20080519010928.GA8797@linux-sh.org>
	 <20080519114515.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain
Date: Sun, 15 Jun 2008 17:19:30 +0100
Message-Id: <1213546770.10290.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 11:47 -0400, Dmitry Torokhov wrote:

> 
> In addition to Pauls comments - is there a reson why maple drivers
> need to brovide both connect/disconnect and probe/remove functions?
> Normally the layer has generic probe/remove defined on bus level and
> individual drivers provide connect/disconnect (or their equivalent)
> which is called from the bus's probe/remove.
> 

Cruft from another era. I will try to clean all that up.

