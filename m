Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZGALsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZGALsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZGALsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:48:46 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:20030
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751557AbZGALsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:48:45 -0400
Message-ID: <4A4B4D1D.8070308@panasas.com>
Date: Wed, 01 Jul 2009 14:48:45 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: tridge@samba.org
CC: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
References: <19013.8005.541836.436991@samba.org>	<20090630063102.GB1351@ucw.cz> <19019.16217.291678.588673@samba.org>
In-Reply-To: <19019.16217.291678.588673@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2009 11:48:49.0347 (UTC) FILETIME=[E5E35930:01C9FA41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2009 01:50 PM, tridge@samba.org wrote:
> Hi Pavel,
> 
> We did of course consider that, and the changes to the patch to
> implement collision avoidance are relatively simple. We didn't do it
> as it would weaken the legal basis behind the patch. I'll leave it to
> John Lanza (the LF patent attorney) to expand on that if you want more
> information.
> 

You completely lost me here. And I thought I did understand the patent
and the fix.

what is the difference between.

short_name = rand(sid);
and
short_name = sid++;

Now if you would do
short_name = MD5(long_name);

That I understand since short_name is some function of long_name
but if I'm just inventing the short_name out of my hat. In what legal
system does it matter what is my random function I use?

> Cheers, Tridge

Boaz
