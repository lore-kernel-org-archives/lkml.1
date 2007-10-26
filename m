Return-Path: <linux-kernel-owner+w=401wt.eu-S1762593AbXJZSAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593AbXJZSAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbXJZSAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:00:30 -0400
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:45135 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbXJZSA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:00:29 -0400
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [2.624-rc1 regression] lost battery information
Cc: aystarik@gmail.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-To: <200710262120.22536.arvidjaar@mail.ru>
References: <200710262024.06012.arvidjaar@mail.ru> <47221C67.9050502@gmail.com> <200710262120.22536.arvidjaar@mail.ru>
Message-Id: <E1IlTTv-0008RL-IH@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Fri, 26 Oct 2007 20:00:27 +0200
X-OriginalArrivalTime: 26 Oct 2007 18:00:27.0831 (UTC) FILETIME=[172F7C70:01C817FA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> I already have power_supply module, battery depends on it and it is
> autloaded. But I fail to see where I can get battery info in /sys

Ah, yes. I see what you mean now and I can confirm the same regression wrt
missing battery data in /proc for my laptop.

$ cat /proc/acpi/battery/BAT1/*
cat: /proc/acpi/battery/BAT1/alarm: Bad address
cat: /proc/acpi/battery/BAT1/info: Bad address
cat: /proc/acpi/battery/BAT1/state: Bad address

Sorry for the earlier misunderstanding.
