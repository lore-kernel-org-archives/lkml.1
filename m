Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZCGXAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZCGXAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 18:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbZCGXAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 18:00:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42352
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbZCGXAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 18:00:09 -0500
Date: Sat, 07 Mar 2009 14:59:53 -0800 (PST)
Message-Id: <20090307.145953.143128544.davem@davemloft.net>
To: jengelh@medozas.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: Change %Z to %z in printf
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LSU.2.00.0903071952180.19385@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903071952180.19385@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>
Date: Sat, 7 Mar 2009 19:54:45 +0100 (CET)

> I found out that %Z is actually a deprecated libc5-ism as printf(3) of 
> man-pages 3.17 dated 2008-12-19 tells me.
> 
> In ${kernel}/lib/vsprintf.c, I find the following note and wondered
> if there might be any objections to going back to 'z'.

GCC's printf formatting checks only started recognizing %z a few
releases ago.  We kept the %Z in there so that with all gcc versions
we won't get warnings.

We've recently increased the minimal GCC version, so going to %z might
be OK now.
