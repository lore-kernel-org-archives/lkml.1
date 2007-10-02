Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbXJBMWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbXJBMWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbXJBMWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:22:15 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:22149 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677AbXJBMWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:22:14 -0400
Message-ID: <470237E3.2020108@ru.mvista.com>
Date: Tue, 02 Oct 2007 16:21:55 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] hpt366: MWDMA filter for SATA cards (take 2)
References: <200709300004.43335.sshtylyov@ru.mvista.com> <200710012312.45552.bzolnier@gmail.com>
In-Reply-To: <200710012312.45552.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>The Marvell bridge chips used on HighPoint SATA cards do not seem to support
>>the MWDMA modes (at least that caould be seen in their so-called drivers :-),
>>so the driver needs to account for this -- to achieve this:

>>- add mdma_filter() method from the original patch by Bartlomiej Zolnierkewicz
>> with his consent,

>> also adding the method callout to ide_rate_filter();

    Ugh, forgot to remove this part -- it's no longer true.

>>- install the method for all chips to only return empty mask if a SATA drive
>>  is detected on HPT372{AN]/374 chips...

>>Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> applied

Thanks,
Sergei
