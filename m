Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZFVM1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZFVM1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZFVM1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:27:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34930 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbZFVM1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:27:03 -0400
Message-ID: <4A3F788A.9000007@redhat.com>
Date: Mon, 22 Jun 2009 14:26:50 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622104435.GA11594@redhat.com> <4A3F757C.6030508@novell.com>
In-Reply-To: <4A3F757C.6030508@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> + * Design note: We create one PIO/MMIO device (iosignalfd_group) which
>>> + * aggregates  one or more iosignalfd_items.  Each item points to exactly one
>>> + * eventfd, and can be registered to trigger on any write to the group
>>> + * (wildcard), or to a write of a specific value.  If more than one item is to
>>> + * be supported, the addr/len ranges must all be identical in the group.  If a
>>> + * trigger value is to be supported on a particular item, the group range must
>>> + * be exactly the width of the trigger.
>>>     
>> Some duplicate spaces in the text above, apparently at random places.
> 
> -ENOPARSE ;)
> 
> Can you elaborate?

I see "aggregates  one".  The others are all at end of sentence, so I 
think that Michael was not talking about those (git grep '\*.*\.  ').

Paolo
