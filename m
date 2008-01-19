Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYASHBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYASHBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 02:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYASHBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 02:01:25 -0500
Received: from 1wt.eu ([62.212.114.60]:1418 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbYASHBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 02:01:24 -0500
Date: Sat, 19 Jan 2008 07:36:36 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Andres Salomon <dilinger@queued.net>, marc.jones@amd.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, wim@iguana.be
Subject: Re: [GEODE] Geode GX/LX watchdog timer (was 2.6.24-rc8 hangs at mfgpt-timer)
Message-ID: <20080119063636.GH8953@1wt.eu>
References: <20080116161912.7b449466@ephemeral> <20080116165606.3ebc06a4@ephemeral> <478F25D6.3060503@i4.informatik.rwth-aachen.de> <20080117134032.4cc1a1cf@ephemeral> <478FB255.5040001@i4.informatik.rwth-aachen.de> <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080119010624.GA25328@cosmic.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119010624.GA25328@cosmic.amd.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 06:06:24PM -0700, Jordan Crouse wrote:
> I don't know how much of a hassle it would be for Andres to get a 2.6.24
> kernel running on the OLPC to make sure that this isn't a regression
> in the timer tick code (I suspect it isn't a regression, but you never
> know).  I also think that it would probably be in our best interest to
> default CONFIG_GEODE_MFGPT_TIMER to 'n' until we get this figured
> out.  Since most BIOSen don't have timers available, that shouldn't affect
> too many people.

Well, I've successfully used earlier version of this code with 2.6.22
on a PCEngines ALIX motherboard equipped with LX800/CS5536. It boots
on a TinyBIOS.

I will try 2.6.24 + this patch on these boards when I have some time.

Willy

