Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbXJVLKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbXJVLKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXJVLKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:10:40 -0400
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:11242 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbXJVLKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:10:40 -0400
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: latest 2.6.23 git missing ACPI POWER_SUPPLY
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-To: <b6a2187b0710220045q2920c0dat9ebe4850b02d1bbf@mail.gmail.com>
References: <b6a2187b0710220045q2920c0dat9ebe4850b02d1bbf@mail.gmail.com>
Message-Id: <E1IjvB3-0005oG-N9@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Mon, 22 Oct 2007 13:10:33 +0200
X-OriginalArrivalTime: 22 Oct 2007 11:10:35.0961 (UTC) FILETIME=[2BA2EA90:01C8149C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> Just pulled latest linux-2.6, and couldn't get ACPI to detect
> ACPI_BATTERY and ACPI_AC.
> 
> It seems ACPI POWER_SUPPLY is still missing.

I had the same problem. It turns out you need to enable
   drivers -> Power supply class support
(either built in or as module) to get ACPI AC/Battery support.

I must say that having these relatively top-level ACPI settings depending on something that is relatively buried away is not very intuitive!
Especially not since at first glance you don't really seem to need that option except for some weird hardware.

CC'ing ACPI mailing list for other opinions.
