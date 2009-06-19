Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbZFSRGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbZFSRGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 13:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZFSRGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 13:06:07 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39485 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZFSRGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 13:06:06 -0400
Message-ID: <4A3BC57B.8000408@in.ibm.com>
Date: Fri, 19 Jun 2009 22:36:03 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PowerPC] 2.6.30-git14 boot failure with SLAB
References: <4A3B615F.8090504@in.ibm.com>
In-Reply-To: <4A3B615F.8090504@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Sant wrote:
> 2.6.30-git14 (0732f87761dbe417cb6e084b712d07e879e876ef) fails to boot
> on various PowerPC machines. Here are last few boot messages from a 
> Power6
> box.
<SNIP>

>
> I will go back and check what changes between git10 and git11
> could have caused this boot failure.
>
The offending commit seems to be c868d550115b9ccc0027c67265b9520790f05601.
mm: Move pgtable_cache_init() earlier

If i revert this commit, the machine boots fine.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

