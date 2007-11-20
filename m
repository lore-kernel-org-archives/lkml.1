Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbXKTXv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbXKTXv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763620AbXKTXvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:51:44 -0500
Received: from waste.org ([66.93.16.53]:44911 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760001AbXKTXvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:51:43 -0500
Date: Tue, 20 Nov 2007 17:51:38 -0600
From: Matt Mackall <mpm@selenic.com>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: System reboot triggered by just reading a device file....!?
Message-ID: <20071120235138.GE17536@waste.org>
References: <2097505946@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2097505946@web.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 12:06:57AM +0100, devzero@web.de wrote:
> - be root

That's your first mistake.

> -  cat /dev/watchdog or dd if=/dev/watchdog of=/dev/zero bs=1 count=1 or .....
> -  wait one minute........
> 
> *reboot*!

And that's the defined behavior of /dev/watchdog, yes. Many years too
late to change it.

> i have heard 2 opinions for now (contacted the author and also discussed on wine-devel ) that this should be expected behaviour.
> 
> being sysadmin quite a while, i cannot believe that (accidentally) reading a device file (being root or not - what does that matter) triggers a system reboot.

If /dev/watchdog can be opened by non-root, that's an installation
error.

-- 
Mathematics is the supreme nostalgia of our time.
