Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZLYEeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZLYEeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 23:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZLYEeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 23:34:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbZLYEeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 23:34:12 -0500
Message-ID: <4B34413E.7060600@redhat.com>
Date: Fri, 25 Dec 2009 12:36:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Allan Stephens <allan.stephens@windriver.com>, netdev@vger.kernel.org,
       Per Liden <per.liden@ericsson.com>,
       tipc-discussion@lists.sourceforge.net, akpm@linux-foundation.org,
       Jon Maloy <jon.maloy@ericsson.com>
Subject: Re: [Patch] tipc: use kconfig to limit numeric ranges
References: <20091225032956.4556.69130.sendpatchset@localhost.localdomain> <31665.1261713006@localhost>
In-Reply-To: <31665.1261713006@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Thu, 24 Dec 2009 22:26:48 EST, Amerigo Wang said:
>> We can rely on kconfig to limit these numbers,
>> no need to limit them at compile time/run time.
> 
>> +          ***Only 1 (one cluster in a zone) is supported by current code.***
>>  
>>            (Max number of clusters inside TIPC zone. Max supported 
>>            value is 4095 clusters, minimum is 1.
> 
> Given the limit of 1, maybe the reference to 4095 should be nuked?
> 

I am not sure, I think the limit of 1 is a temporary choice currently.
