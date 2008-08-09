Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbYHIXpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbYHIXpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 19:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYHIXox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 19:44:53 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:55663 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYHIXow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 19:44:52 -0400
Date: Sun, 10 Aug 2008 02:44:44 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [00/03] [RFC] USB debugging rework
Message-ID: <20080809234443.GD7574@frodo>
Reply-To: me@felipebalbi.com
References: <20080809013820.GA10910@kroah.com> <200808100057.58863.elendil@planet.nl> <20080809233600.GC7574@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809233600.GC7574@frodo>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 02:36:01AM +0300, Felipe Balbi wrote:
> no rebooting. Just rmmod and modprobe again with the parameter set to 0,
> although a sysfs file would be nice, or maybe allowing the
> /sys/module/*/parameters/* to be writable :-)
> 
> I think that should be done in driver core.

Hmm... how clever, nothing should be changed in driver core to make it
work, it already uses the same mode we set in the driver

It should work the way it's done :-)

-- 
balbi
