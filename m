Return-Path: <linux-kernel-owner+w=401wt.eu-S1752298AbXLELjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbXLELjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 06:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXLELjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 06:39:41 -0500
Received: from main.gmane.org ([80.91.229.2]:52176 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXLELjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 06:39:40 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: [PATCH v2] Fix hardware IRQ time accounting problem.
Date: Wed, 5 Dec 2007 11:39:25 +0000 (UTC)
Message-ID: <fj62ld$6eo$1@ger.gmane.org>
References: <20071204055144.GR24243@bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: artipc9.vub.ac.be
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linuxppc-dev@ozlabs.org, linux-usb-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2007 16:51:44 +1100, Tony Breeds wrote:

> The commit fa13a5a1f25f671d084d8884be96fc48d9b68275 (sched: restore
> deterministic CPU accounting on powerpc), unconditionally calls
> update_process_tick() in system context.  In the deterministic
> accounting case this is the correct thing to do.  However, in the
> non-deterministic accounting case we need to not do this, and results in
> the time accounted as hardware irq time being artificially elevated.
> 
> Also this patch collapses 2 consecutive '#ifdef
> CONFIG_VIRT_CPU_ACCOUNTING' checks in time.h into one for neatness.

I can confirm this patch fixed the problem for me. Thank you!

-- 
Frederik Himpe


