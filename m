Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936142Ab0COL3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 07:29:44 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58382 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab0COL3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 07:29:41 -0400
MIME-Version: 1.0
In-Reply-To: <20100315080359.GA15171@linux-sh.org>
References: <20100309065753.GA8287@linux-sh.org> <ac3eb2511003111159q84e6cefi43de106c79c0e333@mail.gmail.com> 
	<20100315080359.GA15171@linux-sh.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 15 Mar 2010 12:29:23 +0100
Message-ID: <ac3eb2511003150429u5aa2e6c8w9ecfcc77293dd82b@mail.gmail.com>
Subject: Re: [PATCH] driver core: Early dev_name() support.
To: Paul Mundt <lethal@linux-sh.org>
Cc: Greg KH <greg@kroah.com>, Magnus Damm <damm@opensource.se>,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 09:03, Paul Mundt <lethal@linux-sh.org> wrote:
> On Thu, Mar 11, 2010 at 08:59:18PM +0100, Kay Sievers wrote:

>> > ??static inline const char *dev_name(const struct device *dev)
>> > ??{
>> > + ?? ?? ?? /* Use the init name until the kobject becomes available */
>>
>> This should probably state that it's used for getting names out of
>> unregistered devices. Otherwise it sounds confusing.
>>
> It's not clear that that distinction makes things any less confusing.
> Early devices are registered, they just haven't been fully initialized
> yet.

For the driver core, "registered" devices are devices where
device_add() or device_register() has been called. Initialized devices
are devices which device_initialize() was called for. The devices you
mean are not "registered" in that sense, right?

Thanks,
Kay
