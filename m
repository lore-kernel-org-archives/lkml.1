Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZGGMXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZGGMXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZGGMX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:23:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60245 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbZGGMX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:23:27 -0400
Date: Tue, 7 Jul 2009 15:22:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
Message-ID: <20090707122250.GC3647@redhat.com>
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com> <4A53372E.6090509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A53372E.6090509@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 02:53:18PM +0300, Avi Kivity wrote:
>>> +		/* address-range must be precise for a hit */
>>>      
>>
>> So there's apparently no way to specify that
>> you want 1,2, or 4 byte writes at address X?
>>    
>
> Why would you want that?

Donnu. Why would anyone want to catch 8 byte writes at all?
Seriously, why add artificial limitations?
IMO, addr=0,len=1 and addr=0,len=2 should not conflict.

-- 
MST
