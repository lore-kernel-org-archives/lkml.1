Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZBDLLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZBDLLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZBDLLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:11:09 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:13458 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751341AbZBDLLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:11:08 -0500
Message-ID: <498977C2.3020305@ru.mvista.com>
Date: Wed, 04 Feb 2009 14:10:58 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>, Jeff Garzik <jgarzik@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils> <20090126191151.18b094e6@lxorguk.ukuu.org.uk>
In-Reply-To: <20090126191151.18b094e6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:
>> [PATCH] libata sff: 32bit PIO use 16bit on slop
>>
>> 871af1210f13966ab911ed2166e4ab2ce775b99d libata: Add 32bit PIO support
>> causes errors on a four-year-old ata_piix Dell Precision 670.  Using
>> 16bit PIO instead of 32bit PIO on the odd 1, 2 or 3 chars fixes that.
>>
>> Signed-off-by: Hugh Dickins <hugh@veritas.com>
>>     
>
> For the 3 bytes of slop it should use a single iowrite32 but otherwise
> that seems ok.

   I'm not really sure what this would achieve but I can post a patch 
implementing this (based on my suggestion to Hugh).

MBR, Sergei


