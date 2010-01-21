Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772Ab0AUR4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0AUR4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620Ab0AUR4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:56:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab0AUR4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:56:09 -0500
Message-ID: <4B589532.9070408@redhat.com>
Date: Thu, 21 Jan 2010 19:56:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] eventfd: allow atomic read and waitqueue remove
References: <20100121162648.GA16458@redhat.com> <alpine.DEB.2.00.1001210857310.8548@makko.or.mcafeemobile.com> <4B588B29.2050100@redhat.com> <20100121172336.GA16707@redhat.com> <4B588FCE.7030803@redhat.com> <20100121173259.GC16707@redhat.com> <4B58933C.4090209@redhat.com> <20100121174538.GG16707@redhat.com>
In-Reply-To: <20100121174538.GG16707@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 07:45 PM, Michael S. Tsirkin wrote:
>
>> But you're in process context.  An eventfd never blocks.
>>      
> Yes it blocks if counter is 0. And we don't know
> it's not 0 unless we read :) catch-22.
>    

Ah yes, I forgot.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

