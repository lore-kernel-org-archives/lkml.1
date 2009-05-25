Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbZEYBc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbZEYBc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 21:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZEYBcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 21:32:19 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:40212 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZEYBcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 21:32:18 -0400
Date: Mon, 25 May 2009 09:31:32 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: linux-kernel@vger.kernel.org
Subject: i2c-viapro / via-fb drivers on VIA CX700
Message-ID: <20090525013132.GA8702@prithivi.gnumonks.org>
References: <200905221139.26941.lkml@morethan.org> <200905240727.30677.lkml@morethan.org> <4A198B24.9040404@zytor.com> <200905241332.39946.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905241332.39946.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 at 01:32:37PM -0500, Michael S. Zick wrote:

> The i2c-viapro driver (in spite of its comments) does not work
> on CX700 (written before manual was released) - it is reading
> the serial number rather than the second data port. ;)
> (No access to the chipset temperature/voltage data on SMBus).

This is surprising.  I just manually verified the driver against the
cx700 programming manual, and it seems to do the right thing.  Lacking
access to a cx700 board right now, I cannot perform an actual test.

Where exactly is the bug about the wrong register that you mentioned?
I'd rather fix that ASAP.

> The via-fb driver just "doesn't work" - Haven't looked at it yet.

good to know.  Seems like I need to get access to a CX700 based board.
 
> There isn't a driver for the hardware watchdog on CX700 - 

JFYI: I wrote one but it doesn't work on the vx800/vx855, and VIA is currently
trying to figure out why.

> There isn't a driver for the machine error reporting -

I think the CPU just claims to report it but in reality doesn't... this was
made to make some proprietary software happy, AFAIR.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison
