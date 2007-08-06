Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbXHFKDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbXHFKDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbXHFKDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:03:05 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3188 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760911AbXHFKDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:03:04 -0400
Date: Mon, 6 Aug 2007 12:03:26 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Arjan van de Ven <arjan@infradead.org>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] msleep() with hrtimers
In-Reply-To: <1186378798.2697.10.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0708061159370.1817@scrub.home>
References: <15327.1186166232@lwn.net>  <Pine.LNX.4.64.0708032116340.1817@scrub.home>
  <1186170407.3153.8.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708032152060.1817@scrub.home>
  <1186185229.3153.11.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708040345530.1817@scrub.home>
  <1186255149.2777.3.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708060150270.1817@scrub.home>
  <1186360983.2697.8.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708060257010.1817@scrub.home>
 <1186378798.2697.10.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 5 Aug 2007, Arjan van de Ven wrote:

> > There's no problem to provide a high resolution sleep, but there is also 
> > no reason to mess with msleep, don't fix what ain't broken...
> 
> John Corbet provided the patch because he had a problem with the current
> msleep... in that it didn't provide as good a common case as he
> wanted... so I think your statement is wrong ;)

Only under the assumptation, that msleep _must_ be "fixed" for all other 
current users too.
Give users a choice to use msleep or nanosleep, how do you know what's 
"best" for them?

bye, Roman
