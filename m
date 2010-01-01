Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114Ab0AAPRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab0AAPRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 10:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896Ab0AAPRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 10:17:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40432 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0AAPRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 10:17:17 -0500
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: backwards busy wait using "time_before()"??
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.LFD.2.00.0912311136560.3596@localhost>
Date: Fri, 01 Jan 2010 16:17:07 +0100
In-Reply-To: <alpine.LFD.2.00.0912311136560.3596@localhost> (Robert P. J. Day's message of "Thu, 31 Dec 2009 11:40:42 -0500 (EST)")
Message-ID: <87tyv57t3g.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@crashcourse.ca> writes:

>                 cpu_relax();                                            \
>         } while (time_before(end_jiffies, jiffies));                    \
>         succeeded;                                                      \
>         })
>
>
>   is it just me, or do those arguments to time_before() look
> backwards?

Yes it looks backwards. The timeout path probably has been never
tested.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
