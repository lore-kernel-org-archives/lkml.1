Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbXBLKul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbXBLKul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 05:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964855AbXBLKul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 05:50:41 -0500
Received: from wasp.net.au ([203.190.192.17]:46477 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964834AbXBLKuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 05:50:40 -0500
Message-ID: <45D0466D.5070806@wasp.net.au>
Date: Mon, 12 Feb 2007 14:50:21 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver - one more
References: <113489.35158.qm@web36703.mail.mud.yahoo.com> <45CDC22B.6040408@drzeus.cx> <45CEB1C9.5010103@wasp.net.au> <45CF3904.5070401@drzeus.cx> <45CF3CA3.1010704@wasp.net.au> <45CF5AB0.6080309@drzeus.cx> <45CF6F64.60500@wasp.net.au> <45D02FFB.5000908@drzeus.cx>
In-Reply-To: <45D02FFB.5000908@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Brad Campbell wrote:
>> brad@bklaptop2:/sys/block/mmcblk0$ ls -laR
>> .:
>> total 0
>> drwxr-xr-x  6 root root    0 2007-02-11 23:29 .
>> drwxr-xr-x 13 root root    0 2007-02-11 23:27 ..
>> -r--r--r--  1 root root 4096 2007-02-11 23:28 dev
>> lrwxrwxrwx  1 root root    0 2007-02-11 23:27 device ->
>> ../../class/mmc_host/mmc0/mmc0:b368
> 
> Is this with CONFIG_SYSFS_DEPRECATED off? It should be pointing to the
> ../../devices tree.
> 
> Rgds

No, it's currently on. I'll recompile and do a dump with it off this evening. Either way, it's still 
broken and in 2.6.19 it wasn't.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
