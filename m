Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbZAEPry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbZAEPry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZAEPro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:47:44 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:18716 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbZAEPro convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:47:44 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.28 hates my RTC clock - with PM_TRACE set
Date: Mon, 5 Jan 2009 16:47:34 +0100
User-Agent: KMail/1.9.9
Cc: Jike Song <albcamus@gmail.com>
References: <df9815e70901050619v6c60e8d4w6868759bb3c36bdb@mail.gmail.com>
In-reply-To: <df9815e70901050619v6c60e8d4w6868759bb3c36bdb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901051647.35442.elendil@planet.nl>
X-OriginalArrivalTime: 05 Jan 2009 15:47:35.0757 (UTC) FILETIME=[EDFA47D0:01C96F4C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I re-compiled 2.6.28 with CONFIG_PM_DEBUG and CONFIG_PM_TRACE set,
> and run this script as per Documentation/power/s2ram.txt:
>
>        #!/bin/sh
>         sync
>         echo 1 > /sys/power/pm_trace
>         echo mem > /sys/power/state

Looks like you forgot to read the rest of the s2ram.txt file, especially 
the bit that starts with "- if it doesn't come back up (which is usually 
the problem) [...]".

The current version [1] also explains why your system clock changes.

Cheers,
FJP

[1]http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/power/s2ram.txt;h=2ebdc6091ce17ff6464aeb4cec35939983045de6;hb=HEAD
