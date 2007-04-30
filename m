Return-Path: <linux-kernel-owner+w=401wt.eu-S1031037AbXD3URJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031037AbXD3URJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031585AbXD3URI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:17:08 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:46467
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031589AbXD3URH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:17:07 -0400
Date: Mon, 30 Apr 2007 13:16:59 -0700
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [REPORT] 2.6.21 vs. 2.6.21-sd046 vs. 2.6.21-CFSv7
Message-ID: <20070430201659.GA5681@gnuppy.monkey.org>
References: <463643A9.5040009@tmr.com> <46364A75.9080003@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46364A75.9080003@tmr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 03:58:45PM -0400, Bill Davidsen wrote:
> Followup: I reran with sd-0.46, setting rr_interval to 40, and then 5 
> (default was 16). Neither appeared to give a useful video playback. I 
> did try setting the make to nice 10, and that made the playback 
> perfectly smooth, as well as response to skip forward and volume change 
> happening when the key was pressed instead of eventually.
> 
> I also tried raising the nice of X to -10, that made things better on 
> display, but I winder if it will let X run ahead of the nice-0 raid threads.
> 
> Is this my hardware or is there a really odd behavior here? The sd seems 
> to be too fair to cope well with this realistic load, and expecting 
> users to nice things is probably morally correct but unrealistic.

People have been reporting very good performance with regards to OpenGL
applications under SD. What is your video driver ? NVidia proprietary ?

OpenGL, X and direct frame buffer access (mplayer and friends) tend not
to interact each other which can result in very different scheduling
characteristics between them.

[please CC the relevant people for their own benefit]

bill

