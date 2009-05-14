Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbZENPml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbZENPml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZENPm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:42:29 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37497 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbZENPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:42:29 -0400
Message-ID: <4A0C3BE1.609@in.ibm.com>
Date: Thu, 14 May 2009 21:12:25 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: David.Woodhouse@intel.com
CC: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Re: Next May 13:[drivers/base/firmware*] Bug while booting on x86
References: <20090513164832.c8a0de7d.sfr@canb.auug.org.au>  <4A0AC5E6.2010402@in.ibm.com> <4A0BACCA.5050103@in.ibm.com>
In-Reply-To: <4A0BACCA.5050103@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Sant wrote:
> Could be because of the following patch which last changed the
> code in question.
>
> firmware: speed up request_firmware()
> http://patchwork.kernel.org/patch/17531/
>
> I will try reverting this patch and check if that helps.
The above mentioned patch seems to be the culprit. If i back out that
patch, the machine boots fine.

David let me know if i can provide any information to debug this
issue.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

