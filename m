Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbXHBPA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbXHBPA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbXHBPAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:00:21 -0400
Received: from wudika.de ([213.239.211.247]:59711 "EHLO wudika.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbXHBPAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:00:20 -0400
Message-ID: <46B1F182.3010608@felicis.org>
Date: Thu, 02 Aug 2007 17:00:18 +0200
From: Martin Roehricht <ml@felicis.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Scheduling the highest priority task
References: <8KLFD-G9-5@gated-at.bofh.it> <46B19CA1.7050204@felicis.org> <20070802114012.GA4067@elte.hu>
In-Reply-To: <20070802114012.GA4067@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2007 01:40 PM, Ingo Molnar wrote:
> in the SMP migration code, the 'old scheduler' indeed picks the lowest 
> priority one, _except_ if that task is running on another CPU or is too 
> 'cache hot':

But why is it, that the scheduler picks the lowest priority one? I 
thought sched_find_first_bit() picks the index of the lowest order bit 
in the bitmap and thus the highest priority job. Is that wrong?
What needs to be changed to let the scheduler pick the highest priority 
task from a given runqueue?
I am very confused ...

Martin
