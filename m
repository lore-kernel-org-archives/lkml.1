Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbZDJB30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbZDJB30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbZDJB3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:29:13 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:17122 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbZDJB3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:29:12 -0400
MIME-Version: 1.0
In-Reply-To: <1239296459.31467.142.camel@calx>
References: <200904061430.26276.rgetz@blackfin.uclinux.org>
	 <200904071744.17727.rgetz@blackfin.uclinux.org>
	 <1239220294.31467.55.camel@calx>
	 <200904090954.54601.rgetz@blackfin.uclinux.org>
	 <1239296459.31467.142.camel@calx>
Date: Thu, 9 Apr 2009 18:29:10 -0700
Message-ID: <a24804730904091829k167668f1y6e546693b2f8e5da@mail.gmail.com>
Subject: Re: IRQF_SAMPLE_RANDOM question...
From: Chris Peterson <cpeterso@cpeterso.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, this is a purely internal interface. Not sure if we need to bother
> with scheduling it. My plan was to simply get the new code in and sweep
> the kernel.

Matt, sounds like you're volunteering? :)

>From my understanding, the roadmap looks something like:

1. Add checkpatch warning about IRQF_SAMPLE_RANDOM
2. Add any new add_*_randomness() functions (e.g. RTC and main clocks?
Serial or USB interrupts?)
3. Remove IRQF_SAMPLE_RANDOM macro (and checkpatch warning)
4. Add "pragmatic entropy accounting model"?


chris
