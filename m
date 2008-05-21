Return-Path: <linux-kernel-owner+w=401wt.eu-S1763044AbYEUSms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044AbYEUSms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbYEUSml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:42:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:65497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbYEUSmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:42:39 -0400
Date: Wed, 21 May 2008 20:42:33 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: LKML <linux-kernel@vger.kernel.org>, kanoj@netxen.com
Subject: Re: kswapd busy but not swapping
In-Reply-To: <1211361217.6463.61.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0805212040390.4890@sheep.housecafe.de>
References: <alpine.DEB.1.10.0805210050440.13780@sheep.housecafe.de> <1211361217.6463.61.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V01U2FsdGVkX1+ImLnwBRwBhA5td6asY8FM6O2ZWlnsqcMoxNM
 wHnwJ4LMD4WYVTSYSUqC2Mc5nGcjEJ4eirQbEmzKnFV6FRJe4Q
 giJyfiPgiqrsnNE/PUo4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Peter Zijlstra wrote:
> It could have been busy reclaiming pagecache.
> kswapd is the generic reclaim thread - paging anonymous memory to the
> swap is but one form thereof.

Hm, OK, so it's "OK" I guess. It stopped after a few hours anyway, I think 
it was related to the disk IO (dd if=/dev/hdd of=/dev/null)....

Thanks for replying,
Christian.
-- 
BOFH excuse #75:

There isn't any problem
