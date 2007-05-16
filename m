Return-Path: <linux-kernel-owner+w=401wt.eu-S1762342AbXEPE7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762342AbXEPE7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 00:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXEPE71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 00:59:27 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:3024 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbXEPE70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 00:59:26 -0400
Message-ID: <464A8F7D.2090409@sw.ru>
Date: Wed, 16 May 2007 08:58:37 +0400
From: Vasily Averin <vvs@sw.ru>
Organization: SW-soft
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.0.10) Gecko/20070301 SUSE/1.8_seamonkey_1.0.8-0.1 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: [patch i2o 5/6] i2o_proc files permission
References: <4649AA6C.2080808@sw.ru>	<4649ABC9.6020605@sw.ru> <20070515174533.1caf24bb@the-village.bc.nu>
In-Reply-To: <20070515174533.1caf24bb@the-village.bc.nu>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 15 May 2007 16:47:05 +0400
> Vasily Averin <vvs@sw.ru> wrote:
> 
>> Reading from some i2o related proc files can lead to the i2o controller hang due
>> unknown reasons. As a workaround this patch changes the permission of these
>> files to root-only accessible.
> 
> I guess you have a crap controller in this case. 
> 
> This isn't the right fix: Detect your specific buggy control and do not
> register the problem /proc nodes for it at all.

Alan,

We have i2o on one of our testnodes: Adaptec Zero channel RAID 2010S integrated
on MSI MS-9136 motherboard and I don't have access to another i2o hardware.
Also I don't have any ideas how to detect buggy i2o node. As far as I understand
Markus is right, and i2o hardware couldn't handle received message that on the
first glance looks correctly.
>From my POV it is bug in firmware and only vendor is able to fix it correctly.
My patch is not a fix but workaround only -- it just do not allow to crash the
node by any user in case when node admin due some reasons has loaded i2o_proc
module.

Thank you,
	Vasily Averin
