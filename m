Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXDEIot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXDEIot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965030AbXDEIot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:44:49 -0400
Received: from styx.suse.cz ([82.119.242.94]:37017 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964988AbXDEIop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:44:45 -0400
Date: Thu, 5 Apr 2007 10:50:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuart_hayes@dell.com
Subject: Re: usb hid: reset NumLock
In-Reply-To: <200704042324.56345.dtor@insightbb.com>
Message-ID: <Pine.LNX.4.64.0704051049010.4173@jikos.suse.cz>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
 <20070402161225.2866c002.zaitcev@redhat.com> <Pine.LNX.4.64.0704031046320.3808@jikos.suse.cz>
 <200704042324.56345.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Dmitry Torokhov wrote:

> Unfortunately my patch is crap. We should not be sending events down 
> dev->event() until dev->open() has been called because many drivers 
> start hardware from there and not ready until then. So it is HID driver 
> responsibility to properly reset leds after all.

Pete, could you please resend your patch, with proper metadata, we need to 
merge your one then.

Thanks,

-- 
Jiri Kosina
