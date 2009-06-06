Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZFFUNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZFFUNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 16:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZFFUNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 16:13:14 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33686 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZFFUNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 16:13:13 -0400
Message-ID: <4A2ACDD8.7010203@in.ibm.com>
Date: Sun, 07 Jun 2009 01:43:12 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Mimi Zohar <zohar@us.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [IMA] 2.6.30-rc8 : Bug while trying to launch a KVM guest
References: <4A2950F0.5050309@in.ibm.com> <OF64D7363D.C87FDEC1-ON852575CC.006F30A6-852575CC.0070CAE8@us.ibm.com>
In-Reply-To: <OF64D7363D.C87FDEC1-ON852575CC.006F30A6-852575CC.0070CAE8@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar wrote:
> This bug has been addressed in linux-next. Please refer to:
>
> f06dd16a03f6f7f72fab4db03be36e28c28c6fd6 : IMA: Handle dentry_open 
> failures
> 1a62e958fa4aaeeb752311b4f5e16b2a86737b23 : IMA: open all files O_LARGEFILE
> 04288f42033607099cebf5ca15ce8dcec3a9688b : integrity: ima audit 
> dentry_open failure
>
> The default policy in 2.6.30 measures all files open for read by root.
> (So starting the VM as root will cause it to be read.)  This linux-next
> patch changes the default behavior so that nothing is measured. 
>
> 5789ba3bd0a3cd20df5980ebf03358f2eb44fd67 :  IMA: Minimal IMA policy and 
> boot param for TCB IMA policy
>   
I am able to boot the kvm guest after applying the following two patches.

commit f06dd16a03f6f7f72fab4db03be36e28c28c6fd6
commit 1a62e958fa4aaeeb752311b4f5e16b2a86737b23

Thanks Mimi for the help.

Regards
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

