Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXDFXjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXDFXjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXDFXjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:39:55 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:45479 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933330AbXDFXjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:39:54 -0400
Date: Sat, 7 Apr 2007 01:38:56 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel-doc: handle spaces in array size
In-Reply-To: <20070406160335.e125e287.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.61.0704070138350.22181@yvahk01.tjqt.qr>
References: <20070406114730.02c82f43.randy.dunlap@oracle.com>
 <Pine.LNX.4.61.0704062117460.6042@yvahk01.tjqt.qr>
 <20070406160335.e125e287.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 6 2007 16:03, Randy Dunlap wrote:
>On Fri, 6 Apr 2007 21:24:48 +0200 (MEST) Jan Engelhardt wrote:
>
>> On Apr 6 2007 11:47, Randy Dunlap wrote:
>> >
>> >Unfortunately, kernel-doc has problems with a struct field like this:
>> >	uint8_t databuf[NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE];
>> >
>> >simply due to the spaces around the "+" sign, so drop all spaces inside
>> >[...] so that parsing is done correctly (in some sense).
>> >
>
>...
>
>> 
>> 	while($arg =~ s/\[(.*)\s+(.*)\]/[$1$2]/) {
>> 	}
>> 
>> should do it, and saves us the pre-matching. (Also note the + at \s)
>> (No need to escape [ and ] in the target pattern.)
>
>Yep, that works.  Want to send it with sign-off or shall I just
>send a new patch to akpm?

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>


Jan
-- 
