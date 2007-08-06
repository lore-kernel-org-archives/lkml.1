Return-Path: <linux-kernel-owner+w=401wt.eu-S1762010AbXHFBDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010AbXHFBDh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 21:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXHFBD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 21:03:28 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2708 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXHFBD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 21:03:27 -0400
Date: Mon, 6 Aug 2007 03:03:50 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Arjan van de Ven <arjan@infradead.org>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] msleep() with hrtimers
In-Reply-To: <1186360983.2697.8.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0708060257010.1817@scrub.home>
References: <15327.1186166232@lwn.net>  <Pine.LNX.4.64.0708032116340.1817@scrub.home>
  <1186170407.3153.8.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708032152060.1817@scrub.home>
  <1186185229.3153.11.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708040345530.1817@scrub.home>
  <1186255149.2777.3.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708060150270.1817@scrub.home>
 <1186360983.2697.8.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 5 Aug 2007, Arjan van de Ven wrote:

> Timers are course resolution that is highly HZ-value dependent. For
> cases where you want a finer resolution, the kernel now has a way to
> provide that functionality... so why not use the quality of service this
> provides..

We're going in circles here. We have two different timer APIs for a 
reason, only because hrtimer provide better resolution, doesn't 
automatically make them the better generic timer.
There's no problem to provide a high resolution sleep, but there is also 
no reason to mess with msleep, don't fix what ain't broken...

bye, Roman
