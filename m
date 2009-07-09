Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbZGIBU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbZGIBU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 21:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbZGIBUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 21:20:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53802 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457AbZGIBUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 21:20:49 -0400
Message-ID: <4A5545CC.9030909@redhat.com>
Date: Wed, 08 Jul 2009 21:20:12 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       chris.mason@oracle.com, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
References: <482d25af-01eb-4c2a-9b1d-bdaf4020ce88@default> <4A55243B.8090001@codemonkey.ws>
In-Reply-To: <4A55243B.8090001@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:

> I have trouble mapping this to a VMM capable of overcommit without just 
> coming back to CMM2.

Same for me.  CMM2 has a more complex mechanism, but way
easier policy than anything else out there.

> In CMM2 parlance, ephemeral tmem pools is just normal kernel memory 
> marked in the volatile state, no?

Basically.

> It seems to me that an architecture built around hinting would be more 
> robust than having to use separate memory pools for this type of memory 
> (especially since you are requiring a copy to/from the pool).

I agree.  Something along the lines of CMM2 needs more
infrastructure, but will be infinitely easier to get right
from the policy side.

Automatic ballooning is an option too, with fairly simple
infrastructure, but potentially insanely complex policy
issues to sort out...

-- 
All rights reversed.
