Return-Path: <linux-kernel-owner+w=401wt.eu-S1761588AbYFDTYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588AbYFDTYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbYFDTYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:24:04 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:12360 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbYFDTYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:24:03 -0400
X-BigFish: VPS-18(z34a4nz1432R98dR1805Mzz10d3izzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4846EBAE.2000604@am.sony.com>
Date: Wed, 4 Jun 2008 12:23:26 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Adrian Bunk <adrian.bunk@movial.fi>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi> <4846E44A.1010601@am.sony.com> <20080604191522.GA18873@uranus.ravnborg.org>
In-Reply-To: <20080604191522.GA18873@uranus.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2008 19:23:49.0977 (UTC) FILETIME=[8466E490:01C8C678]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> I can do a more controlled comparison if you're interested.
> 
> What would be really useful would be to do some king of automated
> monitoring of the size of individual parts of the kernel in
> a few controlled configs.
> And then as son as somethings grows with > 1% for example then to
> bring this to lkml.
> Doing this based on linux-next would allow us to catch the bloaters
> while they are still or just have been doing certain changes.
> 
> It would be nice to tell someone that just enabled som new gcc option
> that this had a cost of 163.432 bytes with a certain config.
> This would get attraction and be dealt with.

This is something I've wanted to get done for the last few
years.  We've crept towards it slowly with things like bloatwatch
and some of the automated testing CELF did for it's (currently
temporarily defunct) test lab.

But we've never gotten to the last bit, which is to fully automate
the testing at the top of tree, and send notifications.  I won't
make any promises, but this is something CELF is very interested in,
and we have parts of the required software already written.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

