Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632Ab0AURgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab0AURgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621Ab0AURgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:36:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab0AURgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:36:04 -0500
Date: Thu, 21 Jan 2010 19:32:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] eventfd: allow atomic read and waitqueue remove
Message-ID: <20100121173259.GC16707@redhat.com>
References: <20100121162648.GA16458@redhat.com> <alpine.DEB.2.00.1001210857310.8548@makko.or.mcafeemobile.com> <4B588B29.2050100@redhat.com> <20100121172336.GA16707@redhat.com> <4B588FCE.7030803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B588FCE.7030803@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 07:33:02PM +0200, Avi Kivity wrote:
> On 01/21/2010 07:23 PM, Michael S. Tsirkin wrote:
>>
>>> I agree.
>>>
>>> But I think we can solve this in another way in .32: we can clear the
>>> eventfd from irqfd->inject work, which is in process context.  The new
>>> stuff is only needed for lockless clearing, no?
>>>      
>> No, AFAIK there's no way to clear the counter from kernel without
>> this patch.
>>    
>
> Can't you read from the file?

IMO no, the read could block.

> -- 
> Do not meddle in the internals of kernels, for they are subtle and quick to panic.
