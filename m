Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYL2WJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYL2WJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 17:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYL2WJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 17:09:10 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:32743 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYL2WJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 17:09:08 -0500
Message-ID: <49594A4D.6050303@oracle.com>
Date: Mon, 29 Dec 2008 14:08:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@hansenpartnership.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kxie@chelsio.com,
       akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, samr <sam@ravnborg.org>
Subject: Re: [PATCH -next v2] cxgb3i: use same dependencies & selects as	CHELSIO_T3
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>	 <20081229130110.67d5271a.randy.dunlap@oracle.com>	 <20081229132312.10934479.randy.dunlap@oracle.com> <1230587887.3302.70.camel@localhost.localdomain>
In-Reply-To: <1230587887.3302.70.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49594A51.00EE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-12-29 at 13:23 -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Make the CXGB iSCSI driver (that selects the CXGB net driver) have the same
>> dependencies as the net driver, since kconfig doesn't do that automatically.
>> Also make it select INET_LRO & FW_LOADER like the net driver does.
> 
> I thought select of a symbol that selected something else propagated
> correctly (even if select of a symbol that depends on something else
> doesn't).

I don't see that happening, at least in this case.
Sam, can you clarify?


> If this is untrue, we have several other Kconfig problems in
> the kernel.

That would not be a surprise.

-- 
~Randy
