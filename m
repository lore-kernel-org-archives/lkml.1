Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYI0OoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYI0OoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 10:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYI0On5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 10:43:57 -0400
Received: from gw.goop.org ([64.81.55.164]:32908 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbYI0On5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 10:43:57 -0400
Message-ID: <48DE46AB.8070505@goop.org>
Date: Sat, 27 Sep 2008 07:43:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, jbarnes@virtuousgeek.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] ioremap sanity check to catch mapping requests exceeding
 the BAR sizes
References: <20080926014334.GF15609@linux-os.sc.intel.com>	<48DDDDDE.7060707@goop.org> <20080927122145.49ad0cf4@lxorguk.ukuu.org.uk>
In-Reply-To: <20080927122145.49ad0cf4@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Any attempt to use ioremap on memory is a bug, so you should warn about
>> that too.
>>     
>
> We use it to ioremap things like the BIOS...

Yeah, that's fine.  I mean using ioremap on system memory is a bug.

    J
