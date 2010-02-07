Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab0BGJsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 04:48:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab0BGJsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 04:48:02 -0500
Date: Sun, 7 Feb 2010 11:44:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] vhost-net: switch to smp barriers
Message-ID: <20100207094441.GA20271@redhat.com>
References: <20100201172101.GA10900@redhat.com> <4B6E8B05.8070607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6E8B05.8070607@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 11:42:29AM +0200, Avi Kivity wrote:
> On 02/01/2010 07:21 PM, Michael S. Tsirkin wrote:
>> vhost-net only uses memory barriers to control SMP effects
>> (communication with userspace potentially running on a different CPU),
>> so it should use SMP barriers and not mandatory barriers for memory
>> access ordering, as suggested by Documentation/memory-barriers.txt
>>
>>    
>
> A UP guest running on an SMP host still needs those barriers.

Correct. And since vhost net is running host-side, smp_XX
barriers will do exactly the right thing, right?

> -- 
> error compiling committee.c: too many arguments to function
