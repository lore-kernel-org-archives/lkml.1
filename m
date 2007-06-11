Return-Path: <linux-kernel-owner+w=401wt.eu-S1763441AbXFKJ56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763441AbXFKJ56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 05:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbXFKJ5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 05:57:52 -0400
Received: from max.aladin.ro ([80.96.155.2]:59852 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbXFKJ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 05:57:51 -0400
Message-ID: <466D1CAC.6060307@aladin.ro>
Date: Mon, 11 Jun 2007 12:58:04 +0300
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 2.6.22-rc4] sysfs: fix race conditions
References: <20070611050107.GJ29122@htj.dyndns.org>
In-Reply-To: <20070611050107.GJ29122@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
Tejun Heo wrote:

> This patchset contains three minimal backports of fixes in -mm.  With
> all patches in the patchset and sysfs-races.patch applied, kernel
> survived ~20 hours of stress test without any problem.
> 

Seriously, do you think adding a few sleeps fixes anything? It just 
makes it harder to happen, and even harder to debug, so this is no good. 
Race condition are fixed by proper locking, ordering and so on.

(No offence, this has to be the patch of the week. :) )
