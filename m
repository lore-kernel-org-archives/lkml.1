Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXCUSqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXCUSqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933591AbXCUSqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:46:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933585AbXCUSqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:46:50 -0400
Message-ID: <4601789B.8040403@redhat.com>
Date: Wed, 21 Mar 2007 14:25:31 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dale Blount <linux-kernel@dale.us>
CC: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: PROBLEM: null pointer dereference in cfq_dispatch_requests	(2.6.21-rc2
 and 2.6.20)
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com>	 <200703011308.28266.linux@f-seidel.de> <20070301123057.GO23985@kernel.dk>	 <loom.20070321T135132-397@post.gmane.org>  <460174EC.8000608@redhat.com> <1174501407.14261.34.camel@dale.velocity.net>
In-Reply-To: <1174501407.14261.34.camel@dale.velocity.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dale Blount wrote:
> On Wed, 2007-03-21 at 14:09 -0400, Chuck Ebbert wrote:
>> Dale Blount wrote:
>>>> I'm puzzled why this is hitting Dan, but no one else has reported
>>>> anything. Dan, did 2.6.19 work for you?
>>> Actually, I believe it is happening to me too.  This is on a 4-disk raid5 with
>>> one failed disk on two 2-port sata_sil pci controller cards.
>>>
>>> The BUG below is from 2.6.20.3, but I will try 2.6.21-rc4 tonight.
>>> The disk didn't fail until 2.6.20, so I don't know if 2.6.19 would have worked
>>> or not.
>>>
>>>
>> Just to be clear: you have a RAID array (what level?) with a failed disk
>> and it's giving you the same error that Dan gets?
> 
> 
> Yes, the BUG looks to be pretty similar to me.  It's a 4 disk raid5 with
> one disk missing (dead and sent in for RMA).
> 

OK, I'm add NeilB to the cc:

(Dan has a RAID6 array with two failed disks.)


