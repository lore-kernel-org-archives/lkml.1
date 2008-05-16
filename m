Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYEPSFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYEPSFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYEPSFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:05:05 -0400
Received: from mx1.ukfsn.org ([77.75.108.10]:58720 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751409AbYEPSFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:05:04 -0400
Message-ID: <482DCCCD.8020503@dgreaves.com>
Date: Fri, 16 May 2008 19:05:01 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>,
       xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com> <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ouch, still on 2.6.25.1 here, didn't reboot yet, but I do not use
> mdraid'ed partitions, just regular mdraid, if you boot back to 2.6.20.7
> does it work again?
Yes, no probs.

It came in prior to 2.6.25-rc1
The machine has a root xfs filesystem with an internal log on a sata disk and a
data filesystem on a partitioned array with an external log (also on the
partitioned array).
Only the partitioned array/external-log filesystem is affected.

David

