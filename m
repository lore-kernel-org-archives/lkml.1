Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYCaHKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYCaHKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 03:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYCaHKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 03:10:40 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:47821 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbYCaHKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 03:10:39 -0400
To: Chr <chunkeey@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
References: <200803302109.22219.chunkeey@web.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 Mar 2008 09:10:34 +0200
In-Reply-To: <200803302109.22219.chunkeey@web.de>
Message-ID: <87wsnj8j2t.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Mar 2008 07:03:57.0351 (UTC) FILETIME=[637BFB70:01C892FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chr <chunkeey@web.de> writes:

> Ever since I went to the new 2.6.25-rcX, I encountered lots of random
> system freezes after about 2 or 3 hours of uptime... but until now, 
> I couldn't _catch_ them, since the system
> (AMD Athlon 4200+ X2 (Manchester) / nforce 4 SLI / x86_64) went
> straight into oblivion (nothing on the serial console or anywhere else,
> heck I couldn't even hit reset, It didn't POST anymore)

Not POSTing would point to some kind of hardware problem. Normally
the kernel shouldn't be able to cause that.

I would recommend you double check if the problem is really not
there with an older kernel by going back there and testing.

-Andi
