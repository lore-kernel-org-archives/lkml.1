Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZJMMrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZJMMrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZJMMrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:47:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbZJMMrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:47:07 -0400
Date: Tue, 13 Oct 2009 09:46:38 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow userspace to adjust kvmclock offset
Message-ID: <20091013124638.GC8092@mothafucka.localdomain>
References: <1254849896-3947-1-git-send-email-glommer@redhat.com> <4AD2EE86.50807@redhat.com> <20091013122828.GZ8092@mothafucka.localdomain> <4AD4730C.9010305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD4730C.9010305@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 03:31:08PM +0300, Avi Kivity wrote:
> On 10/13/2009 03:28 PM, Glauber Costa wrote:
>>
>>> Do we want an absolute or relative adjustment?
>>>      
>> What exactly do you mean?
>>    
>
> Absolute adjustment: clock = t
> Relative adjustment: clock += t
The delta is absolute, but the adjustment in the clock is relative.

So we pick the difference between what userspace is passing us and what
we currently have, then relatively adds up so we can make sure we won't
go back or suffer a too big skew.

