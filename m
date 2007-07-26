Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbXGZIDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbXGZIDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbXGZIDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:03:12 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:37022 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbXGZIDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:03:09 -0400
Message-ID: <46A854C7.4060908@gmail.com>
Date: Thu, 26 Jul 2007 10:01:11 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Bongani Hlope <bhlope@mweb.co.za>
CC: Robert Deaton <false.hopes@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org
Subject: Re: updatedb
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com> <200707260839.51407.bhlope@mweb.co.za> <46A845BB.9080503@gmail.com> <200707260908.02781.bhlope@mweb.co.za>
In-Reply-To: <200707260908.02781.bhlope@mweb.co.za>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2007 09:08 AM, Bongani Hlope wrote:

> On Thursday 26 July 2007 08:56:59 Rene Herman wrote:

>> Great. Now concentrate on the "swpd" column, as it's the only thing 
>> relevant here. The fact that an updatedb run fills/replaces caches is 
>> completely and utterly unsurprising and not something swap-prefetch
>> helps with. The only thing it does is bring back stuff from _swap_.
> 
> ;)
> 
> I have 2Gb of RAM and I never ever touched swap on all my work loads. I
> was just showing the behavior of updatedb on my desktop. I have never
> even looked at the swap-prefetch patch (for obvious reasons).

I see... thanks for the report :)

> I think people should also look at their /proc/sys/vm/overcommit_ratio

In the sense that current stuff might be evicted earlier with no or little 
overcommit?

Rene.

