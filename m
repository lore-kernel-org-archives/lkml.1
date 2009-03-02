Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbZCBKDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbZCBKDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbZCBKDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:03:22 -0500
Received: from mx0.towertech.it ([213.215.222.73]:37891 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756483AbZCBKDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:03:21 -0500
Date: Mon, 2 Mar 2009 11:03:10 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Richard Zidlicky <rz@linux-m68k.org>, rtc-linux@googlegroups.com,
       David Woodhouse <dwmw2@infradead.org>, linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David@ozlabs.org, Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [rtc-linux] Re: [PATCH/RFC 0/5] Generic RTC class driver
Message-ID: <20090302110310.35af50ea@i1501.lan.towertech.it>
In-Reply-To: <alpine.LRH.2.00.0903021051040.25117@vixen.sonytel.be>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<20090220170454.04382e9e@i1501.lan.towertech.it>
	<alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be>
	<1235511327.18632.73.camel@macbook.infradead.org>
	<20090224231154.60ba18d6@i1501.lan.towertech.it>
	<1235514727.18632.93.camel@macbook.infradead.org>
	<alpine.LRH.2.00.0902251059110.4063@vixen.sonytel.be>
	<20090225111836.621412c1@i1501.lan.towertech.it>
	<20090227185514.GA1071@linux-m68k.org>
	<alpine.LRH.2.00.0903021051040.25117@vixen.sonytel.be>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 10:54:14 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> Indeed. You can have a working RTC class driver for lots of hardware by just
> writing ca. 100 lines of code on top of the generic framework.

 That's true, but we would then have two generic frameworks. And one
 of them will have its code scattered all around the kernel.

 So you either use the old rtc framework, which is perfectly functional,
 or you move to the new rtc lass and write the drivers.

 Layering a generic framework over another generic framework
 is quite a nonsense . 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

