Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbXIFMDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbXIFMDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbXIFMDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:03:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34580 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbXIFMDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:03:14 -0400
Date: Thu, 6 Sep 2007 14:03:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Andreas Schwab <schwab@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: modinfo <modulename> question
In-Reply-To: <Pine.LNX.4.64.0709051331190.22864@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0709061401270.25942@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709051232440.22864@p34.internal.lan>
 <jesl5tuj41.fsf@sykes.suse.de> <Pine.LNX.4.64.0709051331190.22864@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 5 2007 13:31, Justin Piszcz wrote:
>>
>> > Is there anyway to get/see what parameters were passed to a kernel 
>> > module?

Not really. Even if a module has parameters exported, they may carry 
default values (and hence, don't fulfill the word "passed", as would be 
the case with `modprobe foo` without {{any extra params} union {params 
in /etc/modprobe*}})

>> /sys/module/<module>/parameters
>
> And under 2.4?

/proc/<module-specific-place>. Generally, even less.



	Jan
-- 
