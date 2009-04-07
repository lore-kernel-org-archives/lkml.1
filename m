Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZDGENT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZDGENT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZDGENF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:13:05 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:59277 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZDGEND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:13:03 -0400
Message-ID: <49DAD2AA.9000604@oracle.com>
Date: Mon, 06 Apr 2009 21:12:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: mmotm 2009-04-05-21-45 uploaded (sysctl)
References: <200904060450.n364oaUj031923@imap1.linux-foundation.org> <20090406210921.9efab09b.randy.dunlap@oracle.com>
In-Reply-To: <20090406210921.9efab09b.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49DAD2A0.00EA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sun, 05 Apr 2009 21:50:36 -0700 akpm@linux-foundation.org wrote:
> 
>> The mm-of-the-moment snapshot 2009-04-05-21-45 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
>>
>> and will soon be available at
>>
>>    git://git.zen-sources.org/zen/mmotm.git
>>
>> It contains the following patches against 2.6.29:
> 
> 
> kernel/sysctl.c: In function '__register_sysctl_paths':
> kernel/sysctl.c:2059: error: 'struct ctl_table_header' has no member named 'dep_map'
> 
> 
> config attached.
> 
> ---
> ~Randy

kernel/sysctl.c: s/CONFIG_DEBUG_LOCK_ALLOC/CONFIG_PROVE_LOCKING/ at line 2056.

-- 
~Randy
