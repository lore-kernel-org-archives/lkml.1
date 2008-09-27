Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbYI0PJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbYI0PJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 11:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYI0PJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 11:09:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:52289 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYI0PJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 11:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,321,1220252400"; 
   d="scan'208";a="444394171"
Message-ID: <48DE4C92.3020806@linux.intel.com>
Date: Sat, 27 Sep 2008 08:09:06 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Suresh Siddha <suresh.b.siddha@intel.com>, jbarnes@virtuousgeek.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ioremap sanity check to catch mapping requests exceeding
 the BAR sizes
References: <20080926014334.GF15609@linux-os.sc.intel.com>	<48DDDDDE.7060707@goop.org> <20080927122145.49ad0cf4@lxorguk.ukuu.org.uk> <48DE46AB.8070505@goop.org>
In-Reply-To: <48DE46AB.8070505@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Alan Cox wrote:
>>> Any attempt to use ioremap on memory is a bug, so you should warn about
>>> that too.
>>>     
>> We use it to ioremap things like the BIOS...
> 
> Yeah, that's fine.  I mean using ioremap on system memory is a bug.
> 

ioremap() already warns on that in a separate check.

>     J

