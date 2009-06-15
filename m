Return-Path: <linux-kernel-owner+w=401wt.eu-S1764852AbZFORvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764852AbZFORvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZFORvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:51:25 -0400
Received: from cpe-72-225-45-7.rochester.res.rr.com ([72.225.45.7]:56213 "EHLO
	death.krwtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZFORvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:51:25 -0400
X-Greylist: delayed 681 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 13:51:24 EDT
Date: Mon, 15 Jun 2009 13:39:57 -0400 (EDT)
From: Ken Witherow <ken@krwtech.com>
Reply-To: Ken Witherow <ken@krwtech.com>
To: Frans Pop <elendil@planet.nl>
cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
Subject: Re: PC speaker beeps in 2.6.30?
In-Reply-To: <200906151857.36576.elendil@planet.nl>
Message-ID: <Pine.LNX.4.64.0906151336010.28623@death.krwtech.com>
References: <4A365DA6.8000102@msgid.tls.msk.ru> <200906151857.36576.elendil@planet.nl>
Organization: KRW Technologies
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Frans Pop wrote:

> For me the system beep has been replaced by a beep in ALSA with .30.
>
> Do you have soundcard that uses HDA? Is CONFIG_SND_HDA_INPUT_BEEP set?
> Does alsamixer show a "beep" control? Is that not muted and does it have
> volume set?

I had this exact same problem. I ran make oldconfig and was never prompted 
for the new HDA config options. I could be wrong, but I can't remember 
make oldconfig behaving this way in the past (or maybe it resulted in 
changes that didn't have any noticeable effect). Having to reconfigure 
the kernel over not being prompted for a new config option which changed 
established behavior was annoying to say the least.
