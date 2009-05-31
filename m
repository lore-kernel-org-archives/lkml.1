Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZEaBhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZEaBhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 21:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZEaBhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 21:37:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:35944 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbZEaBhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 21:37:31 -0400
Message-ID: <4A21DE75.7010202@windriver.com>
Date: Sun, 31 May 2009 09:33:41 +0800
From: Harry Ciao <qingtao.cao@windriver.com>
Reply-To: qingtao.cao@windriver.com
Organization: Wind River, CDC
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: norsk5@yahoo.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: [v1 PATCH 0/2] EDAC: AMD8111 & AMD8131 Kconfig fixup
References: <1242358006-28339-1-git-send-email-qingtao.cao@windriver.com> <20090528004433.4051e83d.akpm@linux-foundation.org>
In-Reply-To: <20090528004433.4051e83d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 May 2009 01:33:09.0647 (UTC) FILETIME=[C14E31F0:01C9E18F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 15 May 2009 11:26:44 +0800 Harry Ciao <qingtao.cao@windriver.com> wrote:
>
>   
>> These are two minor fixups for the AMD8111 and AMD8131 EDAC drivers.
>> The direct reference to device.bus_id should be replaced by dev_name().
>>
>> Add their missing Makefile entires and introduce machine dependency to 
>> their Kconfig options in order to avoid the allmodconfig failure, which
>> I have no better idea to avoid although these chips are not specific to
>> Maple.
>>     
>
> OK, thanks.
>
> Do you think these fixes are safe and desirable for 2.6.30?  (I do).
>
>   
Hi Andrew,

Yes I think so too, I have tested these patches and they work well.

Thanks!

Harry
