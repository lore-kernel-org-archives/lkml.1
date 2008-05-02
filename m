Return-Path: <linux-kernel-owner+w=401wt.eu-S936591AbYEBWJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936591AbYEBWJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbYEBWJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:09:16 -0400
Received: from khc.piap.pl ([195.187.100.11]:36586 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175AbYEBWJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:09:15 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Driver for IXP4xx built-in Ethernet ports
References: <m3r6d05ucg.fsf@maximus.localdomain> <4816B99F.7040102@garzik.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 03 May 2008 00:09:12 +0200
In-Reply-To: <4816B99F.7040102@garzik.org> (Jeff Garzik's message of "Tue\, 29 Apr 2008 02\:01\:03 -0400")
Message-ID: <m3zlr8qrxz.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> the ifdefs are really ugly and want cleaning, but the rest seems
> sane. applied

Thanks.

They (#ifdef __ARMEB__) are indeed very ugly but I don't know how to
clean them, except by splitting the driver into two (which is worse).

The most used things are #defined and then used without those
__ARMEB__ checks.

Duplicating those functions is effectively splitting into two :-(

Well, perhaps Intel could give us firmware which could convert LE-BE
on the fly while TX/RX, that would make the LE code go away.
Binary-only :-(

OTOH I could convert #if* DEBUG_*, I will look at it.
-- 
Krzysztof Halasa
