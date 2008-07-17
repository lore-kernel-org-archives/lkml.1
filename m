Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYGQHAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYGQHAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYGQHAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:00:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57110 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbYGQHAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:00:23 -0400
Message-ID: <487EECD0.3020607@cn.fujitsu.com>
Date: Thu, 17 Jul 2008 14:55:12 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: {build fail} firmware: latest Linus tree modules_install fail
References: <487ED5E3.1060900@cn.fujitsu.com> <1216277072.2480.4.camel@shinybook.infradead.org>
In-Reply-To: <1216277072.2480.4.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse said the following on 2008-7-17 14:44:
> On Thu, 2008-07-17 at 13:17 +0800, Wang Chen wrote:
>> make[1]: *** No rule to make target `/lib/firmware/$(dir', needed by `/lib/firmware/ttusb-budget/dspbootcode.bin'.  Stop.
>> make: *** [_modinst_post] Error 2
>>
>> This error was outputed when I build the latest git tree of Linus's linux-2.6.
> 
> Thank you for the report. Please could you confirm that this fixes it
> for you?
> 
> ----
> Subject: Update scripts/Makefile.fwinst to cope with older make
> 
> Also fix unwanted rebuilds of the firmware/ihex2fw tool by including
> the .ihex2fw.cmd file when present.
> 

compile, build, reboot. all ok.
It fixed my problem. Thank you.

