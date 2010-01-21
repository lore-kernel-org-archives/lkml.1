Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570Ab0AURON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0AURON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948Ab0AUROL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:14:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab0AUROJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:14:09 -0500
Message-ID: <4B588B5D.8050802@redhat.com>
Date: Thu, 21 Jan 2010 19:14:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, mtosatti@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] eventfd: allow atomic read and waitqueue remove
References: <20100121162648.GA16458@redhat.com> <alpine.DEB.2.00.1001210857310.8548@makko.or.mcafeemobile.com> <4B588B29.2050100@redhat.com>
In-Reply-To: <4B588B29.2050100@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 07:13 PM, Avi Kivity wrote:
>
> But I think we can solve this in another way in .32: we can clear the 
> eventfd from irqfd->inject work, which is in process context.  The new 
> stuff is only needed for lockless clearing, no?
>

I meant atomic clearing, when we inject interrupts from the irqfd atomic 
context.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

