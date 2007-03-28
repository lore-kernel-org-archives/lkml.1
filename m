Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbXC1Rp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbXC1Rp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbXC1Rp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:45:26 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58337 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbXC1RpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:45:25 -0400
Date: Wed, 28 Mar 2007 19:45:24 +0200
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2
Message-ID: <20070328174524.GA25709@rhlx01.hs-esslingen.de>
References: <20070326211627.c681af3b.akpm@linux-foundation.org> <20070328170214.GA13044@rhlx01.hs-esslingen.de> <20070328173310.GA4682@rhlx01.hs-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328173310.GA4682@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just wanted to add that when analyzing the backtrace I found the comment
at drivers/char/vt.c/con_close() to be VERY suspicious...
(need to take tty_mutex to prevent concurrent thread tty access).
This might just be what happened here despite trying to protect against it.

Andreas Mohr
