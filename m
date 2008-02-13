Return-Path: <linux-kernel-owner+w=401wt.eu-S932269AbYBMQEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbYBMQEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbYBMQED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:04:03 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:53886 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755793AbYBMQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:04:00 -0500
Message-ID: <47B314C4.2080905@opengridcomputing.com>
Date: Wed, 13 Feb 2008 10:03:16 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.25] RDMA/cxgb3: Fail loopbackconnections.
References: <20080212220929.24442.76874.stgit@dell3.ogc.int>	<adafxvxvgz3.fsf@cisco.com> <015c01c86e21$75317210$05c8a8c0@DIEGO>	<adaskzwuaeu.fsf@cisco.com> <adaodakua9v.fsf@cisco.com> <47B3120B.3040409@opengridcomputing.com>
In-Reply-To: <47B3120B.3040409@opengridcomputing.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> Roland Dreier wrote:
>> Steve, I had to update the patch adding an include and fixing the
>> function declaration (as below)... but how much testing have you done
>> with this??
>>
> 
> Now I understand.  I thought I'd fixed these!  I fixed them locally in 
> the test tree on my victim and then tested, but forgot to update my git 
> tree.
> 
> Sorry for this.
> 
> You want me to resubmit?
> 

BTW: Testing:  I cloned my git tree, resolved the two compile issues 
(void + include), then built and installed the kernel (2.6.25-rc1 + the 
fixed patch).  I then ensured that a connection to the local address 
caused the ENOSYS error.

I just forgot to pull the updated file back into my stg managed git tree.

:(
