Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZCISvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZCISvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZCISvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:51:15 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:52764 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754091AbZCISvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:51:11 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 14:51:11 EDT
X-BigFish: VPS-27(zz98dR936eQ9371Pzzzzz2fh6bh)
Message-ID: <49B5618E.9050501@am.sony.com>
Date: Mon, 9 Mar 2009 11:35:58 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Kyle McMartin <kyle@mcmartin.ca>, rtc-linux@googlegroups.com,
       linux-parisc@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Dann Frazier <dannf@dannf.org>
Subject: Re: [PATCH 7/7] powerpc/ps3: Add rtc-ps3
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <1236605183-22718-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2009 18:35:59.0266 (UTC) FILETIME=[E429A820:01C9A0E5]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2009 06:26 AM, Geert Uytterhoeven wrote:
> Create a real RTC driver for PS3, and unhook the deprecated
> ppc_md.[gs]et_rtc_time.

>  8 files changed, 132 insertions(+), 18 deletions(-)

Sorry, I hadn't been following the discussion closely, but
could you explain why we are going from a generic framework
where we hook in our platform specific part to a totally
independent driver that has such an increase in code size.

Why couldn't you fix the generic part so that udev could
load it automatically?

I much prefer to have this code in the platform support
code as it was.  It is much more effort (a pain) to maintain
a separate driver were I have to cater to a subsystem's
maintainer, and with this rtc it seems everyone who was
using the generic PPC driver will need to do the same.

-Geoff

