Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXLCF0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXLCF0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 00:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXLCF0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 00:26:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:35504 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbXLCF0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 00:26:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=W6whML2YzZWb/6rzGaSOmFbcJUdqUH8lDGGNx/v6W3NeCYtAVCQz2k9CZG+xXkO+7+UGaMiOsYFYRpot2jfwrnL21ffRsb+2PkKj2DYB8sT6lv5CsaNpZ7Fw7CnKTwVqMAC8iLaoXW/0SFoaW1EnVStVa5Zh51K/5DEu4i7cX2M=
Message-ID: <47539374.1090402@gmail.com>
Date: Mon, 03 Dec 2007 14:26:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Lindroth <thomas.lindroth@gmail.com>
Subject: Re: 2.6.24-rc3-git6: Reported regressions from 2.6.23
References: <200712012312.42136.rjw@sisk.pl> <200712020347.01769.bzolnier@gmail.com>
In-Reply-To: <200712020347.01769.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Saturday 01 December 2007, Rafael J. Wysocki wrote:
> 
>> Subject		: 2.6.24-rc1: pata_amd fails to detect 80-pin wire
>> Submitter	: "Thomas Lindroth" <thomas.lindroth@gmail.com>
>> References	: http://lkml.org/lkml/2007/11/7/152
>> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9322
>> Handled-By	: Tejun Heo <htejun@gmail.com>
>> 		  Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Patch		: http://lkml.org/lkml/2007/11/11/115
> 
> Tejun's rework of cable detection code which fixes the problem has
> been just applied into "upstream" (not "upstream-fixes") so it is
> destined for 2.6.25 (I wasn't on cc: BTW) and since I got no feedback
> on my patch (below) which also happens to fix the regression, was
> acked by Alan, tested by Thomas and has been in -mm for 3 weeks now
> I assume that everybody is happy with it (Jeff/Tejun: you were also
> on cc: when the patch was merged into -mm)..

I wasn't too sure about the fix because this doesn't deal with many
cases where 40C cables are detected as 80C but it should definitely fix
the specific regression && looks sane for #upstream too.

Thanks.

-- 
tejun
