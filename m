Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbZBIRB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbZBIRB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZBIRBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:01:21 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:34705 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZBIRBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:01:20 -0500
Message-ID: <49906157.9090707@oracle.com>
Date: Mon, 09 Feb 2009 09:01:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, swise@chelsio.com,
       general@lists.openfabrics.org, Roland Dreier <rolandd@cisco.com>
Subject: Re: linux-next: Tree for February 9 (infiniband)
References: <20090209193908.1a448944.sfr@canb.auug.org.au> <49905F93.300@oracle.com> <49906118.3060801@opengridcomputing.com>
In-Reply-To: <49906118.3060801@opengridcomputing.com>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.4990614C.0304:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>  
>>> Hi all,
>>>
>>> [I accidentally deleted the merge and quilt-import logs today :-( - I
>>> wonder if any would have noticed :-).  The merge summary still appears
>>> below.]
>>>
>>> Changes since 20090206:
>>>     
>>
>>
>> allyesconfig build on i386 fails with:
>>
>> drivers/built-in.o: In function `iwch_sgl2pbl_map':
>> /usr/builds/linux-next-20090209/drivers/infiniband/hw/cxgb3/iwch_qp.c:237:
>> undefined reference to `__umoddi3'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>>
>> or allmodconfig on i386 fails with:
>>
>> ERROR: "__umoddi3" [drivers/infiniband/hw/cxgb3/iw_cxgb3.ko] undefined!
>>
>>   
> 
> Somehow changing offset to a u64 must have caused this.  What is
> __umoddi3?  (it can't be good) :)

It's some kind of mod operation, like 64-bit % 32-bit or
64-bit % 64-bit.  Should be in a fairly recent change.


-- 
~Randy
