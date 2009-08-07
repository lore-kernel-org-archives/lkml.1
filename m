Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZHGK1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZHGK1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZHGK1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:27:45 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:59491 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbZHGK1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:27:45 -0400
Message-ID: <4A7C019C.4090003@gmail.com>
Date: Fri, 07 Aug 2009 12:27:40 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Henk Martijn <h.h.martijn@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [bisected] boot speed regression in current git
References: <4A7BFCC4.8060006@gmail.com>
In-Reply-To: <4A7BFCC4.8060006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 07 Aug 2009 12:27:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henk Martijn a écrit :
> hi,
> 
> in current git my booting takes > 20 s longer. 
> 
> I bisected this to "net: restore the original spinlock to protect unicast list" commit: a6ac65db2329e7685299666f5f7b6093c7b0f3a0
> reverting this commit gives me back 20 s in boot time. 
> 
> I've attached the two dmesg logs. 
> 
> I can help with testing if necessary. 
> 
> Regards,
> 
> Henk 

Could you try Ingo fix ?

http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=0bf52b981770cbf006323bab5177f2858a196766

Should be pulled soon
