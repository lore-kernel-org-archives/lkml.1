Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZKWXFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZKWXFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZKWXFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:05:00 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:55325 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZKWXE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:04:59 -0500
Message-ID: <4B0B1507.4060202@oracle.com>
Date: Mon, 23 Nov 2009 15:04:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 23
References: <20091123185232.1423c56b.sfr@canb.auug.org.au> <20091123111510.9b0c0714.randy.dunlap@oracle.com> <200911240924.54675.rusty@rustcorp.com.au>
In-Reply-To: <200911240924.54675.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B0B1514.0147:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 24 Nov 2009 05:45:10 am Randy Dunlap wrote:
>> On Mon, 23 Nov 2009 18:52:32 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20091120:
>>
>> Hey rr,
>>
>> This patch "param\:remove-useless-writable-charp.patch" has several typos
>> that cause build errors in drivers/staging/.  I sent patches for these errors
>> to gregkh but he couldn't apply them.  Please build STAGING (drivers/staging/)
>> crap along with other build testing when you make changes.
> 
> Hi Randy,
> 
>     Fixed.  And I guess linux-next doesn't build staging?  Seems a fair call,
> I should have done so.

I decided to check on linux-next (only checked x86_64 allmodconfig),
and viola:

CONFIG_STAGING=y
CONFIG_STAGING_EXCLUDE_BUILD=y

That is just too helpful.  :(

-- 
~Randy
