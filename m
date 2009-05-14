Return-Path: <linux-kernel-owner+w=401wt.eu-S1761368AbZENMX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368AbZENMX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760322AbZENMWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:22:55 -0400
Received: from h155.mvista.com ([63.81.120.155]:3937 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760944AbZENMWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:22:53 -0400
Message-ID: <4A0C0D44.9020308@ru.mvista.com>
Date: Thu, 14 May 2009 16:23:32 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] ide: merge ide_disk_special() into do_special()
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>	 <20090513205200.28638.90827.sendpatchset@localhost.localdomain> <1242248102.4639.17.camel@Joe-AcerAspire>
In-Reply-To: <1242248102.4639.17.camel@Joe-AcerAspire>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Joe Perches wrote:

>>While at it:
>>- change debug printk() level to KERN_DEBUG
>>- update documentation

>>There should be no functional changes caused by this patch.

>>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>---
>> drivers/ide/ide-io.c |   44 ++++++++++++++++++--------------------------
>> 1 file changed, 18 insertions(+), 26 deletions(-)

>>Index: b/drivers/ide/ide-io.c
>>===================================================================
>>--- a/drivers/ide/ide-io.c
>>+++ b/drivers/ide/ide-io.c
>>@@ -184,11 +184,28 @@ static void ide_tf_set_setmult_cmd(ide_d

> []

>>+#ifdef DEBUG
>>+	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name, s->all);
>>+#endif

> pr_debug?

    Yes, and the number of arguments doesn't correspond to the number of the 
format specifiers.

WBR, Sergei
