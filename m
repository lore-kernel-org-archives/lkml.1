Return-Path: <linux-kernel-owner+w=401wt.eu-S1031366AbXDZR0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031366AbXDZR0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031368AbXDZR0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:26:16 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:47331 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031366AbXDZR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:26:15 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 13:26:15 EDT
Message-ID: <4630DF19.3060805@kernel.org>
Date: Thu, 26 Apr 2007 10:19:21 -0700
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
References: 20070425232806.GL17387@elf.ucw.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> For suspend to ram, in contrast, since you *know* that nobody will be 
>> touching the hardware, and since the timings are very different anyway 
>> (you'd hope that you can resume in a second or two), you'd generally want 
>> to keep the DMA engine tables right where they are, and just literally 
>> suspend the PCI chip itself.
> 
> I'd actually prefer resume to be similar to module insert, too... Do
> you think that resume is _that_ time critical?

http://www.gettysfamily.org/wordpress/?p=32
http://www.gettysfamily.org/wordpress/?p=33

You cannot resume "too fast"; suspend to RAM should become so fast that you
use it without even thinking about it.

- Josh Triplett

