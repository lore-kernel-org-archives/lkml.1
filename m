Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbZDAW7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbZDAW7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761204AbZDAW65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:58:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757304AbZDAW6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:58:55 -0400
Message-ID: <49D3F088.50600@redhat.com>
Date: Thu, 02 Apr 2009 01:54:00 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       chrisw@redhat.com, riel@redhat.com, jeremy@goop.org,
       mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net, yaniv@redhat.com,
       dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
References: <1238457560-7613-5-git-send-email-ieidus@redhat.com> <49D17C04.9070307@codemonkey.ws> <49D20B63.8020709@redhat.com> <49D21B33.4070406@codemonkey.ws> <20090331142533.GR9137@random.random> <49D22A9D.4050403@codemonkey.ws> <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random> <49D24A02.6070000@codemonkey.ws>
In-Reply-To: <49D24A02.6070000@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Andrea Arcangeli wrote:
>> On Tue, Mar 31, 2009 at 10:54:57AM -0500, Anthony Liguori wrote:
>>  
>>> You can still disable ksm and simply return ENOSYS for the MADV_ 
>>> flag.  You     
>>
>>
Anthony, the biggest problem about madvice() is that it is a real system 
call api, i wouldnt want in that stage of ksm commit into api changes of 
linux...

The ioctl itself is restricting, madvice is much more...,

Can we draft this issue to after ksm is merged, and after all the big 
new fetures that we want to add to ksm will be merge....
(then the api would be much more stable, and we will be able to ask ppl 
in the list about changing of api, but for new driver that it yet to be 
merged, it is kind of overkill to add api to linux)

What do you think?

