Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbZDSI0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbZDSI0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZDSIZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:25:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49931 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZDSIZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:25:44 -0400
To: VomLehn <dvomlehn@cisco.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] Wait for console to become available, v2
From: Andi Kleen <andi@firstfloor.org>
References: <20090416190837.GA26734@cuplxvomd02.corp.sa.net>
Date: Sun, 19 Apr 2009 10:25:37 +0200
In-Reply-To: <20090416190837.GA26734@cuplxvomd02.corp.sa.net> (VomLehn's message of "Thu, 16 Apr 2009 12:08:37 -0700")
Message-ID: <874owlqcce.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VomLehn <dvomlehn@cisco.com> writes:
>
> History
> v2	Wait for the preferred console rather than any console. Make the
> 	delay interval a tunable.

CONFIG tunables are usually a bad idea. What should a binary distribution
kernel set? Better make it a boot option with a reasonable default.

Also a setting to panic in this case might be useful, normally a system
without console is not very useful and needs to be rebooted anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
