Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774Ab0ATSCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab0ATSCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899Ab0ATSCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:02:15 -0500
Received: from mail-bw0-f222.google.com ([209.85.218.222]:43305 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab0ATSCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:02:14 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 13:02:14 EST
MIME-Version: 1.0
In-Reply-To: <20100117065803.6e5e089e@infradead.org>
References: <1263505677.2074.2.camel@yio.site> <20100115065638.005ac690@infradead.org> 
	<20100115180341.GA12146@kroah.com> <20100117065803.6e5e089e@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 20 Jan 2010 18:53:49 +0100
Message-ID: <ac3eb2511001200953g3fc2be3ay30174b0429707c93@mail.gmail.com>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by 
	default
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 15:58, Arjan van de Ven <arjan@infradead.org> wrote:
> On Fri, 15 Jan 2010 10:03:41 -0800
> Greg KH <greg@kroah.com> wrote:
>> > removing experimental is fine... but setting it by default is a bit
>> > over the top and very inconsistent with how the 'default' option is
>> > used.
>>
>> Why?
>
> because the convention is that we use "default y" only for those things
> that used to be on, and are now turned into a config option.

Oh, I never heard of such a convention. Sure, we can remove that "y",
if this is the way it should be used, not be used.

Looking at the current Kconfig files many "default y" looks more like:
"stuff that should be in a kernel to work in a common setup". I see
new functionality often switched on with that flag.

As said, I don't mind dropping that "y", if there is such a convention.

Thanks,
Kay
