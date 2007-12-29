Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbXL2TSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbXL2TSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 14:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXL2TS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 14:18:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbXL2TSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 14:18:25 -0500
Date: Sat, 29 Dec 2007 11:18:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: Top 9 kernel oopses/warnings for the week of December 29th,
 2007
In-Reply-To: <477630CF.5070609@linux.intel.com>
Message-ID: <alpine.LFD.0.9999.0712291116190.2778@woody.linux-foundation.org>
References: <477630CF.5070609@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 29 Dec 2007, Arjan van de Ven wrote:
>
> It has been a quiet week due to the holidays, only 55 oops traces
> have been collected.

This would be more useful if it was more readable. As it is, you seem to 
have some formatting errors in your automation, where the things are 
incorrectly grouped:

> Rank 1: sysctl_head_finish
> 	sysctl table check failed
> 	Reported 7 times
> 	Only reported for the proprietary madwifi driver
> 	More info: http://www.kerneloops.org/search.php?search=sysctl_head_finish
> 	Rank 2: __ieee80211_rx
> 	Warning at net/mac80211/rx.c:1672

ie notice how that "Rank 2" got reported as if it was part of the "Rank 1" 
issue. 

		Linus
