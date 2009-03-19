Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbZCSGdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbZCSGdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbZCSGdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:33:35 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54939 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbZCSGde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:33:34 -0400
Message-ID: <49C1E736.1000508@in.ibm.com>
Date: Thu, 19 Mar 2009 12:03:26 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: jfs-discussion@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, shaggy@austin.ibm.com
Subject: Re: [Jfs-discussion] [BUG/JFS/2.6.29-rc8] kernel BUG at fs/mpage.c:473!
References: <49BDFB4F.7040405@in.ibm.com> <alpine.DEB.2.01.0903180259110.16244@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0903180259110.16244@bogon.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau wrote:
> On Mon, 16 Mar 2009, Sachin Sant wrote:
>   
>> autorun: reading command 85 /usr/local/autobench/scripts/autobench.dat
>> autorun: run test fsstress -d $scratchdir -l $iterations: command read
>> autorun: run test fsstress -d /mnt/tmp -l 1: was expanded
>> 03/15/2009-19:36:37 processing command: (1) 'run test fsstress -d /mnt/tmp -l 1'
>>     
>
> How many iterations were really run to hit this BUG? When I specify "-l 
> 1", fsstress[0] comes back instantly (and no error of course)...
>   
Sorry for the late reply. Somehow i missed this mail.

Yeah with default option values fsstress completes in a jiffy. I generally
invoke fsstress with 1000 operations per process (-n 1000) and 1000
processes (-p 1000).

fsstress -d /mnt/tmp -l 1 -n 1000 -p 1000

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

