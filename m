Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbXHISkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbXHISkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXHISkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:40:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbXHISkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:40:36 -0400
Message-ID: <46BB5F9B.6050808@redhat.com>
Date: Thu, 09 Aug 2007 14:40:27 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: i386 doublefault handler is broken with CONFIG_DEBUG_SPINLOCK
References: <46BB4599.2020900@redhat.com> <p73zm10egym.fsf@bingen.suse.de>
In-Reply-To: <p73zm10egym.fsf@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2007 01:49 PM, Andi Kleen wrote:
> Chuck Ebbert <cebbert@redhat.com> writes:
>> Initializing FS in the doublefault_tss should fix it.
>>
>> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
>>
>> ---
>>
>>  NOTE: not even compile tested.
> 
> Can you please test it?
> 

It compiles but I can't really test it further right now.
