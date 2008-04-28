Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbYD1JRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbYD1JRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYD1JQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:16:50 -0400
Received: from OSB1387.piap.pl ([195.187.100.11]:38586 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbYD1JQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:16:49 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] Driver for IXP4xx built-in Ethernet ports
References: <m3r6d05ucg.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 28 Apr 2008 11:16:46 +0200
In-Reply-To: <m3r6d05ucg.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Sun\, 20 Apr 2008 19\:06\:39 +0200")
Message-ID: <m34p9mfif5.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Adds a driver for built-in IXP4xx Ethernet ports.

Thanks for applying those other two patches, Jeff.

And if you worry about this one and specifically about these two
included fixes to arch/arm/mach-ixp4xx/ixp4xx_npe.c and ixp4xx_qmgr.c,
I believe they don't need to go through Russell's patch system, and
I maintain the files, there is no potential conflict. I guess you can
take this patch safely.

Alternatively I can omit the changes and submit them separately, your
call.

You have already acked a previous version of this driver, I have
changed NAPI interface (as needed by 2.6.24) since then.

TIA.
-- 
Krzysztof Halasa
