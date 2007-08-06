Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbXHFFl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbXHFFl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 01:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbXHFFlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 01:41:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40248 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXHFFlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 01:41:18 -0400
Subject: Re: [PATCH] msleep() with hrtimers
From: Arjan van de Ven <arjan@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0708060257010.1817@scrub.home>
References: <15327.1186166232@lwn.net>
	 <Pine.LNX.4.64.0708032116340.1817@scrub.home>
	 <1186170407.3153.8.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708032152060.1817@scrub.home>
	 <1186185229.3153.11.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708040345530.1817@scrub.home>
	 <1186255149.2777.3.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060150270.1817@scrub.home>
	 <1186360983.2697.8.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060257010.1817@scrub.home>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 05 Aug 2007 22:39:58 -0700
Message-Id: <1186378798.2697.10.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 03:03 +0200, Roman Zippel wrote:

> There's no problem to provide a high resolution sleep, but there is also 
> no reason to mess with msleep, don't fix what ain't broken...

John Corbet provided the patch because he had a problem with the current
msleep... in that it didn't provide as good a common case as he
wanted... so I think your statement is wrong ;)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

