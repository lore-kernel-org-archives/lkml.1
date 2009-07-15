Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbZGOSno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbZGOSno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbZGOSnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:43:43 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:61569 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbZGOSnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <20090715152702.GB21611@dtor-d630.eng.vmware.com>
References: <20090714100634.GA4054@elf.ucw.cz>
	 <20090714175201.GB14661@dtor-d630.eng.vmware.com>
	 <20090715134855.GB2538@elf.ucw.cz>
	 <20090715152702.GB21611@dtor-d630.eng.vmware.com>
Date: Wed, 15 Jul 2009 11:43:41 -0700
Message-ID: <d6200be20907151143r3d159e8esd078055c57ee7986@mail.gmail.com>
Subject: Re: Support for synaptic touchscreen in HTC dream
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 8:27 AM, Dmitry
Torokhov<dmitry.torokhov@gmail.com> wrote:
...
>> > I think threaded IRQ will fit the bill and will take care of
>> > IRQ/workqueue shutdown races. Of course you still need to use workqueue
>> > if polling.
>>
>> I guess we'll just strip polling version for now?
>>
>
> Well, is it useable in polling mode? Do we forsee any devices using it
> that way? If no then shure, strip it out.

I would not consider polling mode acceptable in a shipping device. It
was somewhat useful during bringup since it allowed testing the
touchscreen without a working interrupt.

-- 
Arve Hjønnevåg
