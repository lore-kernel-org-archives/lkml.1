Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbYERGkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbYERGkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 02:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYERGkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 02:40:09 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:42550
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYERGkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 02:40:08 -0400
Message-ID: <482FCF45.1050307@qumranet.com>
Date: Sun, 18 May 2008 09:40:05 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Mark McLoughlin <markmc@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
References: <1209565906-9019-1-git-send-email-markmc@redhat.com> <1210865380.16012.15.camel@muff> <482C579F.4030509@qumranet.com> <200805160925.18087.rusty@rustcorp.com.au>
In-Reply-To: <200805160925.18087.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (firebolt.argo.co.il [0.0.0.0]); Sun, 18 May 2008 09:40:05 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Friday 16 May 2008 01:32:47 Avi Kivity wrote:
>   
>> Mark McLoughlin wrote:
>>     
>>> I think Rusty is speaking from the POV of the guest driver - i.e. that
>>> virtio_net should never disable notifications on the xmit queue using
>>> disable_cb()?
>>>
>>> Sounds like you think agree, but that the host side should throttle the
>>> rate of xmit notifications?
>>>       
>> Yes.
>>     
>
> But performance is going to suck in the meantime, as currently our host 
> doesn't do this.
>   

That's what the feature bits are for.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

