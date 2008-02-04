Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbYBDTdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbYBDTdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYBDTdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:33:44 -0500
Received: from xerxes.tchmachines.com ([208.76.80.175]:42840 "EHLO
	xerxes.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbYBDTdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:33:43 -0500
X-Greylist: delayed 1997 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2008 14:33:43 EST
Message-ID: <3713.69.30.58.166.1202151624.squirrel@architechnical.net>
Date: Mon, 4 Feb 2008 14:00:24 -0500 (EST)
Subject: Re: [UPDATED v4] WM97xx touchscreen drivers
From: linux01@architechnical.net
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - xerxes.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - architechnical.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:

> This patch series adds support for the touchscreen controllers provided
> by Wolfson Microelectronics WM97xx series chips in both polled and
> streaming modes.
>

I integrated this patch with our 2.6.24 kernel and it broke our APM-based
battery monitor, which uses an ADC channel on the 9712.  Support for this
multi-function chip series seems to be in a few places; would it make
sense to have one generic WM97xx driver in drivers/mfd and stack the
codec, touchscreen, etc, drivers logically above (in their respective
areas)?  In my experience with the Wolfson series a change to the sound
driver breaks touchscreen, a change to the touchscreen driver changes ADC
readings, etc, so I wanted to open dialog on what the right direction may
be as various Wolfson code starts making its way into the mainline.

Thanks,
Pete MacKay

