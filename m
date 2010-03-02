Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0CBQuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 11:50:18 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:53213 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab0CBQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 11:50:16 -0500
Date: Tue, 02 Mar 2010 11:50:15 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Oops while booting 2.6.34-rc0 (block pull busted)
In-reply-to: <hmiocs$p6h$1@dough.gmane.org>
To: walt <w41ter@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4B8D41C7.1030404@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <201003011615.31709.dmitry.torokhov@gmail.com>
 <20100302075656.GO5768@kernel.dk> <20100302081547.GP5768@kernel.dk>
 <hmiocs$p6h$1@dough.gmane.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7)
 Gecko/20100111 Lightning/1.0b2pre Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/2/2010 5:13 AM, walt wrote:
> On 03/02/2010 12:15 AM, Jens Axboe wrote:
>>> On Mon, Mar 01 2010, Dmitry Torokhov wrote:
>
>>>> It looks like block tree that has been pulled today into mainline is
>>>> busted, I am getting the Opps below on boot with the following commit:
>>>>
>>>> commit b1bf9368407ae7e89d8a005bb40beb70a41df539
>
>
>> ....Can you also try and see if reverting
>> 9f7cdbc33f36d28e57eaba0093f68f0d14c38c5b makes it work?
>
> I'm getting the same oops and reverting that commit fixes it, thanks.
> I'm happy to test patches, etc.
>
Same here - was unable to boot - revert of this solved the issue.

