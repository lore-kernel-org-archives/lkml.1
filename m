Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbYGXJky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbYGXJky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYGXJkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:40:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44423 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751089AbYGXJkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:40:45 -0400
Date: Thu, 24 Jul 2008 10:19:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Ben Dooks <ben-linux@fluff.org>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>, hmh@hmh.eng.br,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
 accelerometers etc)
Message-ID: <20080724101957.75bf03e0@lxorguk.ukuu.org.uk>
In-Reply-To: <20080724074124.GB2254@local>
References: <488763AD.4050400@gmail.com>
	<20080723191918.GC26938@trinity.fluff.org>
	<20080724074124.GB2254@local>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hwmon is designed for slow I/O. It won't handle an ADC that does a few
> megasamples/sec.

At that rate I would assume you want a memory mapped ring buffer or
similar not a sysfs style interface ?
