Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbZCIOAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbZCIOAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 10:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZCIN7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:59:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:42387 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZCIN7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:59:51 -0400
Subject: Re: [PATCH 6/7] powerpc: Hook up rtc-generic, and kill rtc-ppc
From: David Woodhouse <dwmw2@infradead.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Kyle McMartin <kyle@mcmartin.ca>, rtc-linux@googlegroups.com,
       linux-parisc@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Dann Frazier <dannf@dannf.org>
In-Reply-To: <1236605183-22718-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1236605183-22718-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 13:59:41 +0000
Message-Id: <1236607181.572.180.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 14:26 +0100, Geert Uytterhoeven wrote:
> PowerPC has been a long time user of the generic RTC abstraction, so hook up
> rtc-generic:
>   - Create the "rtc-generic" platform device if ppc_md.get_rtc_time is set,
>   - Kill rtc-ppc, as rtc-generic offers the same functionality in a more
>     generic way, and supports autoloading through udev.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Acked-By: David Woodhouse <David.Woodhouse@intel.com>

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

