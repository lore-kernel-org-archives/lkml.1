Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbZBMQiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbZBMQiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbZBMQiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:38:46 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:47406 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675AbZBMQip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:38:45 -0500
Message-ID: <4995A20A.2060802@oracle.com>
Date: Fri, 13 Feb 2009 08:38:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org
Subject: Re: [PATCH -next] x86_32: fix printk formats
References: <20090212194408.ff7489c1.sfr@canb.auug.org.au> <49946DB8.9030801@oracle.com> <20090213082556.GB4606@elte.hu>
In-Reply-To: <20090213082556.GB4606@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4995A1E9.02CF:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix printk format warnings and also change 2 %ld to %lu for unsigned long
>> variables.
>>
>> arch/x86/mm/init_32.c:727: warning: format '%u' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
>> arch/x86/mm/init_32.c:735: warning: format '%u' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  arch/x86/mm/init_32.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Already fixed in the x86 tree, but thanks.

OK, but this still shows up in linux-next of 20090213.
Did the fix just miss the today's pull or is there a git #branch issue
or what?

Thanks,
-- 
~Randy
