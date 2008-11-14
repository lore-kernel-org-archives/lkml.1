Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYKNAPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYKNAPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYKNAPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:15:31 -0500
Received: from h155.mvista.com ([63.81.120.155]:37065 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754647AbYKNAPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:15:30 -0500
Message-ID: <491CC31C.7090606@ru.mvista.com>
Date: Fri, 14 Nov 2008 03:15:24 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>
Subject: Re: [PATCH] New IDE/block driver for OCTEON SOC Compact Flash interface.
References: <491C7F28.2070507@caviumnetworks.com> <491CC0B6.8020400@ru.mvista.com>
In-Reply-To: <491CC0B6.8020400@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> As part of our efforts to get the Cavium OCTEON processor support
>> merged (see: http://marc.info/?l=linux-mips&m=122600487218824), we
>> have this CF driver for your consideration.
>>
>> Most OCTEON variants have *no* DMA or interrupt support on the CF
>> interface so a simple bit-banging approach is taken.  Although if DMA is
>> available, we do take advantage of it.
>>
>> The register definitions are part of the chip support patch set
>> mentioned above, and are not included here.
>>
>> At this point I would like to get feedback as to whether this is a
>> good approach for the CF driver, or perhaps generate ideas about other
>> possible approaches.
>
>   It's totally unacceptable for drivers/ide/ as this is 
> self-containeed driver no using IDE core for anything, so this can 
> only fit well to drivers/block/.

   I probably need to clarify that it will hardly be accepted into 
drivers/block/ as well, being a mere CF driver.

MBR, Sergei


