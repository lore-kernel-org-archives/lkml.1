Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbXIMLD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbXIMLD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 07:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXIMLDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 07:03:48 -0400
Received: from mailout04.sul.t-online.de ([194.25.134.18]:50764 "EHLO
	mailout04.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbXIMLDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 07:03:47 -0400
Message-ID: <46E918FD.3070607@t-online.de>
Date: Thu, 13 Sep 2007 13:03:25 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070810)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: Mike Frysinger <vapier.adi@gmail.com>, bernd.schmidt@analog.com,
       linux-arch@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Uclinux-dist-devel] Re: [PATCH] Blackfin arch: add some missing
 syscall
References: <1189670203.30686.15.camel@roc-desktop>	<20070913081852.GC17367@parisc-linux.org>	<8bd0f97a0709130137l55977c28w95cf8527ae8b9e24@mail.gmail.com> <1189673849.30686.28.camel@roc-desktop>
In-Reply-To: <1189673849.30686.28.camel@roc-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: bjc5b-Z-Zed34kqo0iJBvvhDanl4csD5VroZUrLZAsLivhK8wu8Rgv
X-TOI-MSGID: bbaf52c6-f934-48f5-bdd6-17574dc0866b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
>>> but mremap doesn't -- there's even an implementation in mm/nommu.c.
>>> Could you check the rest of these over to see if they truly don't need
>>> to be implemented for no-mmu?
>> you're right we want mremap, my fault
>>
> 
> Yes, I do think so, both sys_mremap and sys_munmap are implemented in
> mm/nommu.c. How do think of this, Bernd?

There's a mremap in nommu.c, but it doesn't do a lot that is useful. 
With some further mm changes in our tree, it's little more than a fancy 
way of saying munmap, and uClibc does not use it, so there's no 
compelling need to have it in userspace.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
