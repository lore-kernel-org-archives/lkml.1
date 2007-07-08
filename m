Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbXGHKMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbXGHKMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 06:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbXGHKMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 06:12:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:8572 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbXGHKMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 06:12:03 -0400
Date: Sun, 8 Jul 2007 12:12:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jim Cromie <jim.cromie@gmail.com>
cc: Linux kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, davem@davemloft.net
Subject: Re: Coding style on function signatures  (was: Convert tasklets to
 work queues )
In-Reply-To: <46903483.3020205@gmail.com>
Message-ID: <Pine.LNX.4.64.0707081209260.1536@fbirervta.pbzchgretzou.qr>
References: <20070622182051.859570787@goodmis.org> <20070622182315.571740041@goodmis.org>
 <20070623095359.4667514e.akpm@linux-foundation.org>
 <alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
 <20070623115252.fc36f20c.rdunlap@xenotime.net>
 <alpine.LFD.0.98.0706231209130.3593@woody.linux-foundation.org>
 <46903483.3020205@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 7 2007 18:49, Jim Cromie wrote:
> forex:
>
> static ssize_t
> store_fan_div (struct device *dev, struct device_attribute *devattr,
>                   const char *buf, size_t count)
> {...}
>
> IIRC, many like the entire sig on one line, because its grep friendly.
> I personally like the above, but grep-ability is hard to argue against.
>
> The above has 2 violations (of strict-grep-ability rule)
> 1 - return sig is separate

I can only think of one case where it's ok, when the first line is quite long
already:

static __attribute__((pure)) inline const uint32_t
hashfunction(parameter1, parameter2, ...)
{
}


	Jan
-- 
