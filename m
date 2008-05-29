Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYE2MdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYE2MdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 08:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYE2MdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 08:33:07 -0400
Received: from dsl093-193-175.stl1.dsl.speakeasy.net ([66.93.193.175]:53028
	"EHLO hades.sngx.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751349AbYE2MdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 08:33:06 -0400
Message-ID: <483EA2D1.8050603@sngx.net>
Date: Thu, 29 May 2008 07:34:25 -0500
From: James Cammarata <jimi@sngx.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool - e1000/pcnet32
References: <482DA5B6.1020606@sngx.net>	<482DB46A.8020103@cosmosbay.com>	<482EF192.4070707@sngx.net>	<482F5113.5090703@cosmosbay.com>	<482F610D.2080108@sngx.net>	<20080518003104.GK28241@solarflare.com>	<482FBA09.80201@sngx.net>	<483E0AAE.2020107@sngx.net> <20080528221118.63da4092.akpm@linux-foundation.org>
In-Reply-To: <20080528221118.63da4092.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You didn't provide a reason from adding this feature to the kernel.

Sorry, my reasoning was in my original patch only.  The ability to reset network 
counters is, in my experience, one of the first things you do when trying to 
troubleshoot networking issues - especially when you have incrementing errors.


> Many of the kernel's accounting accumulators cannot be reset.  We
> handle that in userspace tools by using subtraction.

I don't think that should preclude the ability to reset these, unless it is
shown that it would break something very badly.
