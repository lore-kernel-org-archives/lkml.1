Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbXLRLjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbXLRLjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 06:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXLRLja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 06:39:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbXLRLja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:39:30 -0500
Message-ID: <4767B154.7010507@redhat.com>
Date: Tue, 18 Dec 2007 06:39:00 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gregory Haskins <ghaskins@novell.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: dynamically update the root-domain span/online
 maps
References: <20071218023805.4390.19471.stgit@novell1.haskins.net> <20071218105513.GA9002@elte.hu>
In-Reply-To: <20071218105513.GA9002@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> well since i reverted the original patch, there's no regression. The 
> question is, do we know whether this new patch works fine wrt. s2ram?
> 

Hi Ingo,

I included the same patches into 2.6.23.9-rt13 and someone reported s2r 
failed for them. I've included Greg's updates into a pre release of 
-rt14 and sent that to the reporter. I'm waiting on a response before 
releasing -rt14.

Although I did just get a response from Andrew Morton saying that the 
updated patch fixed his box.

-- Steve

