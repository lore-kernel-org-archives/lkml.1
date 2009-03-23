Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbZCWViw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbZCWViw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZCWVil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:38:41 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:19164 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZCWVik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:38:40 -0400
Message-ID: <49C7F302.6030004@oracle.com>
Date: Mon, 23 Mar 2009 13:37:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for March 23 (media/video/hdpvr)
References: <20090323205454.d0cbf721.sfr@canb.auug.org.au> <49C7D965.5080202@oracle.com> <20090323204940.GA5079@aniel>
In-Reply-To: <20090323204940.GA5079@aniel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49C80155.0025:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Janne Grunau wrote:
> Hi,
> 
> On Mon, Mar 23, 2009 at 11:48:05AM -0700, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>> Changes since 20090320:
>>> The v4l-dvb tree gained a build failure for which I have reverted 3 commits.
>> drivers/built-in.o: In function `hdpvr_disconnect':
>> hdpvr-core.c:(.text+0xf3894): undefined reference to `i2c_del_adapter'
>> drivers/built-in.o: In function `hdpvr_register_i2c_adapter':
>> (.text+0xf4145): undefined reference to `i2c_add_adapter'
>>
>>
>> CONFIG_I2C is not enabled.
> 
> following patch should fix that.

Ack.  Thanks.

> Janne
> 
> ps: Mauro, I'll send a pull request shortly


-- 
~Randy
