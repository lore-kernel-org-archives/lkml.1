Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYJaAEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYJaAEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 20:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbYJaAEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 20:04:30 -0400
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:30934 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754179AbYJaAE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 20:04:29 -0400
From: Frans Pop <elendil@planet.nl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: Long delays and keystrokes required - related to disk encryption?
Date: Fri, 31 Oct 2008 01:04:25 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200810281744.52587.elendil@planet.nl> <20081030195031.GA22805@elf.ucw.cz>
In-Reply-To: <20081030195031.GA22805@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810310104.25932.elendil@planet.nl>
X-OriginalArrivalTime: 31 Oct 2008 00:04:26.0594 (UTC) FILETIME=[3CF1C420:01C93AEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2008, Pavel Machek wrote:
> Try "nohz=off highres=off"...

Oh, I have no doubt that that could help. The point is though that I don't 
think I should have to use such parameters.

I think we've already established that disabling hires timers helps, so, 
unless this will provide some additional tracing info to the developers, 
I think I'll skip this suggestion.

2.6 28-rc2 is a regression against 2.6.27 because hires is broken. I don't 
think I'll want to permanently add random boot parameters to work around 
that regression.

Cheers,
FJP
