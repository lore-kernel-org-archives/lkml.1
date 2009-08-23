Return-Path: <linux-kernel-owner+w=401wt.eu-S933805AbZHWNhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbZHWNhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbZHWNhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:37:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933665AbZHWNhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:37:45 -0400
Date: Sun, 23 Aug 2009 16:36:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
Message-ID: <20090823133620.GA12841@redhat.com>
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com> <20090820175540.GA9232@redhat.com> <4A8D90BB.2030506@redhat.com> <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A913DA9.1020403@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 04:01:29PM +0300, Avi Kivity wrote:
> On 08/20/2009 09:28 PM, Michael S. Tsirkin wrote:
>>>> I thought the point was to move assigned devices out of KVM?
>>>>
>>>>        
>>> Grr.  Forgot about that.
>>>
>>> That's much more important.
>>>      
>> Looks like we'll have do with a separate char device or
>> something?
>>    
>
> We can still tunnel it through userspace.

More important here is realization that eventfd is a mutex/semaphore
implementation, not a generic event reporting interface as we are trying
to use it.

> Most assigned devices will  
> have MSI.  uio can signal the eventfd when the level changes, qemu can  
> read the level and write it to kvm.
> -- 
> error compiling committee.c: too many arguments to function
