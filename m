Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbYLOP5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbYLOP5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 10:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYLOP5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 10:57:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57066 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYLOP5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 10:57:06 -0500
Date: Mon, 15 Dec 2008 16:56:55 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
Message-ID: <20081215155655.GA1535@ucw.cz>
References: <gi247o$iog$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gi247o$iog$1@ger.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-12-14 05:06:01, Brian J. Murrell wrote:
> I'm trying to debug a resume problem on a compaq presario C700 laptop on 
> the Ubuntu 2.6.24-22-generic kernel.
> 
> I've used the /sys/power/pm_trace facility to debug the problem to the
> following:
> 
> [   31.212062]   Magic number: 0:716:374
> [   31.212115]   hash matches /build/buildd/linux-2.6.24/drivers/base/power/main.c:97
> [   31.212255]   hash matches device LNXVIDEO:00
> 
> Not sure where to go from here though.  Devices in this machine are:

Sounds like acpi video driver to me. So you may want to rmmod it
before suspend at see what happens. (and cc linux-acpi).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
