Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbYEOQnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbYEOQnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYEOQnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:43:08 -0400
Received: from xenotime.net ([66.160.160.81]:34176 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751648AbYEOQnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:43:07 -0400
Date: Thu, 15 May 2008 09:43:04 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       stern@rowland.harvard.edu
Subject: Re: Linux 2.6.25.4
In-Reply-To: <20080515150721.GA8420@kroah.com>
Message-ID: <Pine.LNX.4.64.0805150942070.7254@shark.he.net>
References: <20080515150721.GA8420@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Greg Kroah-Hartman wrote:

> We (the -stable team) are announcing the release of the 2.6.25.4 kernel.
> 
> It contains a bunch of bug fixes, and one security update, so all users
> of the 2.6.25 series are encouraged to upgrade.

Build errors on i386 and x86_64 allyesconfig:

drivers/usb/host/ohci-sm501.c:242: error: 'hcd' undeclared (first use in this function)
drivers/usb/host/ohci-sm501.c:242: error: (Each undeclared identifier is reported only once
drivers/usb/host/ohci-sm501.c:242: error: for each function it appears in.)
make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1

-- 
~Randy
