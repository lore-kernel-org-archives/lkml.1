Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZCJQU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZCJQU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbZCJQUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:20:46 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:9304 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZCJQUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:20:44 -0400
X-BigFish: VPS-42(zz1432R98dR936eQ1805M9371Pzzzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <49B692EC.1020505@am.sony.com>
Date: Tue, 10 Mar 2009 09:18:52 -0700
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
X-OriginalArrivalTime: 10 Mar 2009 16:18:52.0744 (UTC) FILETIME=[E72FC480:01C9A19B]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2009 06:26 AM, Geert Uytterhoeven wrote:
> Create a real RTC driver for PS3, and unhook the deprecated
> ppc_md.[gs]et_rtc_time.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Cc: Geoff Levand <geoffrey.levand@am.sony.com>
> ---
>  arch/powerpc/include/asm/ps3.h        |    3 +
>  arch/powerpc/platforms/ps3/os-area.c  |    2 +
>  arch/powerpc/platforms/ps3/platform.h |    2 -
>  arch/powerpc/platforms/ps3/setup.c    |    2 -
>  arch/powerpc/platforms/ps3/time.c     |   26 ++++-----
>  drivers/rtc/Kconfig                   |    9 +++
>  drivers/rtc/Makefile                  |    1 +
>  drivers/rtc/rtc-ps3.c                 |  105 +++++++++++++++++++++++++++++++++
>  8 files changed, 132 insertions(+), 18 deletions(-)
>  create mode 100644 drivers/rtc/rtc-ps3.c

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

