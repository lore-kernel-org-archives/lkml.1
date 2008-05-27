Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYE0FTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYE0FTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 01:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYE0FTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 01:19:39 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:33806 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYE0FTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 01:19:39 -0400
Message-ID: <483B99DA.4070905@krogh.cc>
Date: Tue, 27 May 2008 07:19:22 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Abhijit Menon-Sen <ams@toroid.org>
CC: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <483B2A9B.4050007@krogh.cc> <alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org> <483B60DB.7020402@gmx.net> <483B6287.2000202@gmx.net> <20080527015243.GA19756@toroid.org>
In-Reply-To: <20080527015243.GA19756@toroid.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhijit Menon-Sen wrote:
 > At 2008-05-27 03:23:19 +0200, c-d.hailfinger.devel.2006@gmx.net wrote:
 >> The change is
 >> Signed-off-by: Carl-Daniel Hailfinger 
<c-d.hailfinger.devel.2006@gmx.net>
 >> in case someone makes a patch from it.
 >
 > Here you go.
 >
 > -- ams
 >
 > diff --git a/drivers/mtd/maps/ck804xrom.c b/drivers/mtd/maps/ck804xrom.c
 > index 59d8fb4..effaf7c 100644

Ok. Patch applied. The stacktrace goes away, but I still get these:

[42949399.211630] ck804xrom ck804xrom_init_one(): Unable to register 
resource 0x00000000ffb00000-0x00000000ffffffff - kernel bug?
[42949399.399754] CFI: Found no ck804xrom @ffc00000 device at location zero
[42949399.409759] JEDEC: Found no ck804xrom @ffc00000 device at location 
zero
[42949399.409759] CFI: Found no ck804xrom @ffc00000 device at location zero
[42949399.409759] JEDEC: Found no ck804xrom @ffc00000 device at location 
zero
[42949399.409759] CFI: Found no ck804xrom @ffc00000 device at location zero
[42949399.409759] JEDEC: Found no ck804xrom @ffc00000 device at location 
zero
[42949399.409759] CFI: Found no ck804xrom @ffc10000 device at location zero
[42949399.409759] JEDEC: Found no ck804xrom @ffc10000 device at location 
zero
[42949399.409759] CFI: Found no ck804xrom @ffc10000 device at location zero
[42949399.409759] JEDEC: Found no ck804xrom @ffc10000 device at location 
zero
[42949399.409759] CFI: Found no ck804xrom @ffc10000 device at location zero
... and many more.

The system works Ok anyway.

-- 
Jesper

