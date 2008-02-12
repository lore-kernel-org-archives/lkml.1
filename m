Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYBLAYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYBLAYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYBLAYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:24:21 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:10311 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbYBLAYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Z6zJEkRwKMAXfXhRLHGbxnqC3JrkQDhZ3PV58DE+zcTSKLM7j5fzGRb6wZA0zkUQZw9La5FYUwKOHrojcHbp97k5cGX/2AWlbj+lDuXdrQPIwlh5DcpPwR5pjuBW11cZ095VG7KLQRakdE2WZjA4ORxHRaAhCCLY2h4FnPS/tTM=
Message-ID: <47B0E72C.3050305@gmail.com>
Date: Tue, 12 Feb 2008 09:24:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH #upstream] libata: implement libata.force module parameter
References: <47A3375F.80101@gmail.com> <47A356C3.3010904@garzik.org> <20080201183621.GC14759@uranus.ravnborg.org> <47ABD817.2020903@gmail.com>
In-Reply-To: <47ABD817.2020903@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Sam Ravnborg wrote:
>> I have lost the actual patch.
>> But what you see is what happens when you mix const and non-const data
>> in the same section.
>>
>> Look for use of __initdata for const data and replace it with __initconst.
>>
>> And modpost cannot warn about it as gcc errors out before we look at the
>> .o file with modpost.
> 
> OIC, thanks.  Hmmm... in init.h, I see __{dev|cpu|mem}initconst but no
> __initconst.  The data structure in question is used from module init
> function tagged properly with __init.  What should be done here?

PING.

-- 
tejun
