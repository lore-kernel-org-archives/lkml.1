Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbZDCDP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbZDCDP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 23:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZDCDPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 23:15:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:44620 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbZDCDPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 23:15:11 -0400
Message-ID: <49D57E92.4000508@windriver.com>
Date: Fri, 03 Apr 2009 11:12:18 +0800
From: Harry Ciao <qingtao.cao@windriver.com>
Reply-To: qingtao.cao@windriver.com
Organization: Wind River, CDC
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: norsk5@yahoo.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: [v0 PATCH 3/5] EDAC: Add CPC925 driver Kconfig & Makefile
References: <1238652440-9224-1-git-send-email-qingtao.cao@windriver.com> <1238652440-9224-3-git-send-email-qingtao.cao@windriver.com> <1238652440-9224-4-git-send-email-qingtao.cao@windriver.com> <200904021434.04558.arnd@arndb.de>
In-Reply-To: <200904021434.04558.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Apr 2009 03:14:54.0907 (UTC) FILETIME=[5C5D70B0:01C9B40A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann 写道:
> On Thursday 02 April 2009, Harry Ciao wrote:
>   
>> +config EDAC_CPC925
>> +       tristate "IBM CPC925 Memory Controller (PPC970FX)"
>> +       depends on EDAC_MM_EDAC
>> +       help
>> +         Support for error detection and correction on the
>> +         IBM CPC925 Bridge and Memory Controller, which is
>> +         a companion chip to the PowerPC 970 family of
>> +         processors.
>>     
>
> This needs to depend on PPC64 as well, so it won't show up
> on other architectures.
>
> 	Arnd <><
>
>   
Thanks Arnd, I will correct this in next version patches.

Cheers,

Harry
