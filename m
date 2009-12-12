Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbZLLJdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbZLLJdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 04:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760506AbZLLJdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 04:33:36 -0500
Received: from lo.gmane.org ([80.91.229.12]:50683 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758202AbZLLJde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 04:33:34 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: ael <ael@none.none>
Subject: Re: Unable to format or use floppies since 2.6.28
Date: Sat, 12 Dec 2009 09:33:14 +0000
Message-ID: <hfvo0q$pvp$1@ger.gmane.org>
References: <4B215007.4030703@compro.net>
Reply-To: law_ence.dev@ntlworld.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc2-oxfd6-0-0-cust581.oxfd.cable.ntl.com
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
In-Reply-To: <4B215007.4030703@compro.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> I have many boxes. They all do the same thing. Running different versions of SuSE, 10.3-11.2. Any kernel at or above 2.6.28 fails to fdformat a floppy. These same machines, using the same floppies and drives, running kernels older than 2.6.28 work just fine. I googled and found other such reports but no solution. I know better than to just assume it's a kernel bug but it sure looks like it could be so I'm inquiring about it here. 
> 
> 
> # fdformat /dev/fd0u1440
> Double-sided, 80 tracks, 18 sec/track. Total capacity 1440 kB.
> Formatting ... done
> Verifying ... Problem reading cylinder 1, expected 18432, read 2048

Similar problems on debian testing: see
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=548434

However, fdformat is ok on Gentoo under 2.6.31 and also on Ubuntu
2.6.32-rc6, so it seems it is not just the kernel version in any
simplistic way.

A git-bisect seems the obvious next step?

ael


