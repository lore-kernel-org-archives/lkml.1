Return-Path: <linux-kernel-owner+w=401wt.eu-S932762AbYEHWqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbYEHWqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbYEHWqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:46:06 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64006 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754254AbYEHWqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:46:05 -0400
Date: Thu, 8 May 2008 23:43:34 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Jean Delvare <khali@linux-fr.org>, Alessandro Zummo <a.zummo@towertech.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
In-Reply-To: <20080508045106.GB25531@linux-mips.org>
Message-ID: <Pine.LNX.4.55.0805082311410.5944@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
 <20080507085953.2c08b854@hyperion.delvare> <Pine.LNX.4.55.0805072145040.25644@cliff.in.clinika.pl>
 <20080508045106.GB25531@linux-mips.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Ralf Baechle wrote:

> I like it; we maybe should consider getting rid of most of the libs-* stuff
> in arch/mips/Makefile.  Some of it might be causing subtle bugs such as
> routines exported to modules not getting linked into the kernel proper.

 Well, I think it should be reasonable to convert everything but lib/, the
latter being used for various implicit bits like strcpy() or whatever some
version of GCC may come up with.  Plus possibly generic code overridable
by boards for optimisation; I am not sure if we have got left any at the
moment though.

 With the much better configuration language of 2.6 and more and more 
stuff being done by magic sections bits built as libraries cause more 
hassle than convenience.

  Maciej
