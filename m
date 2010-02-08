Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab0BHDSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 22:18:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab0BHDSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 22:18:35 -0500
Message-ID: <4B6F834E.4010801@redhat.com>
Date: Mon, 08 Feb 2010 11:21:50 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Octavian Purdila <opurdila@ixiacom.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, linux-rdma@vger.kernel.org,
       netdev@vger.kernel.org, nhorman@tuxdriver.com,
       linux-sctp@vger.kernel.org
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port
 numbers
References: <201002031312.48531.opurdila@ixiacom.com> <201002042015.51092.opurdila@ixiacom.com> <4B6BA272.4090405@redhat.com> <201002051405.54029.opurdila@ixiacom.com>
In-Reply-To: <201002051405.54029.opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> On Friday 05 February 2010 06:45:38 you wrote:
> 
>> Again, using bitmap algorithm is not a problem and it's better, the
>> problem is sysctl interface, how would you plan to interact with users
>> via sysctl/proc if you use bitmap to handle this? I would like to hear
>> more details about this.
>>
> 
> We could use something like positive values for setting and negative for reset 
> (e.g. 3 would set the port in the bitmap and -3 would reset it).


Hmm, then how do you output the info of those ports? Arrays of bitmaps?

> 
> But we would need new sysctl and proc handlers to handle the bitmap case (e.g. 
> sysctl_bitmap, proc_dobitmap_minmax).

Maybe.

Thanks.
