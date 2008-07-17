Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbYGQDlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbYGQDlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 23:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYGQDky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 23:40:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37128 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYGQDkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 23:40:53 -0400
Message-ID: <487EBF1E.5030109@jp.fujitsu.com>
Date: Thu, 17 Jul 2008 12:40:14 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>, Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout v2
References: <487B05CE.1050508@jp.fujitsu.com> <487D78A3.6050105@jp.fujitsu.com> <487DC943.5060202@goop.org>
In-Reply-To: <487DC943.5060202@goop.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Hidetoshi Seto wrote:
>> +#ifdef CONFIG_STOP_MACHINE
>> +extern unsigned long stopmachine_timeout;
>> +#endif
> 
> No externs in C files. Put it in an appropriate header.

sysctl.c already has many externs... but I can fix at least
the above.

> I'll do a proper review soon.

Is it better to postpone v4 until your comment comes?

Thanks,
H.Seto
