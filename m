Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZHTSG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZHTSG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 14:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZHTSG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 14:06:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbZHTSGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 14:06:25 -0400
Message-ID: <4A8D90BB.2030506@redhat.com>
Date: Thu, 20 Aug 2009 21:06:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com> <20090820175540.GA9232@redhat.com>
In-Reply-To: <20090820175540.GA9232@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 08:55 PM, Michael S. Tsirkin wrote:
>
>> While we could argue about this my feeling is that we should drop this,
>> at least until we can quantify what benefit it has and whether there are
>> any Davide-acceptable alternatives.
>>
>> In the meanwhile, we can let vhost-net support edge-triggered interrupts
>> only, let qemu terminate those eventfds and convert then to
>> level-triggered interrupts (which it can then inject using the existing
>> ioctl).  It will keep vhost-net and kvm simpler at the cost of some
>> performance penalty to guests using level interrupts.  These suck anyway
>> so we'll point users at msi.
>>      
> I thought the point was to move assigned devices out of KVM?
>    

Grr.  Forgot about that.

That's much more important.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

